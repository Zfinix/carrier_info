package com.chizi.carrier_info

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.telephony.SubscriptionInfo
import android.telephony.SubscriptionManager
import android.telephony.TelephonyCallback
import android.telephony.TelephonyDisplayInfo
import android.telephony.TelephonyManager
import android.telephony.cdma.CdmaCellLocation
import android.telephony.euicc.EuiccManager
import android.telephony.gsm.GsmCellLocation
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withTimeoutOrNull
import java.util.concurrent.Executor
import kotlin.coroutines.resume

private const val DISPLAY_INFO_TIMEOUT_MS = 500L

/** Reads every field on its own, so one missing permission or API only empties that field. */
private inline fun <T> field(read: () -> T): T? = try {
    read()
} catch (e: Exception) {
    null
}

@SuppressLint("MissingPermission", "HardwareIds")
internal class AndroidCarrierApiImpl(private val context: Context) : AndroidCarrierApi {
    private val telephonyManager: TelephonyManager? =
        context.getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager
    private val subscriptionManager: SubscriptionManager? =
        context.getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as? SubscriptionManager

    override suspend fun getAndroidInfo(): AndroidCarrierMessage {
        val tm = telephonyManager
            ?: throw FlutterError("no_telephony", "This device has no telephony service.", null)

        val subscriptions = field { subscriptionManager?.activeSubscriptionInfoList }.orEmpty()
        val slotCount = field { tm.phoneCount } ?: 1

        return AndroidCarrierMessage(
            isVoiceCapable = field { tm.isVoiceCapable },
            isDataEnabled = field {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) tm.isDataEnabled else null
            },
            isDataCapable = field {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) tm.isDataCapable else null
            },
            isMultiSimSupported = field {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) multiSimSupport(tm) else null
            },
            isSmsCapable = field { tm.isSmsCapable },
            subscriptionsInfo = subscriptions.map(::subscription),
            telephonyInfo = (0 until slotCount).map { slot ->
                telephony(tm, slot, subscriptions.firstOrNull { it.simSlotIndex == slot })
            },
            activeDataSubscriptionId = field {
                when {
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.R -> SubscriptionManager.getActiveDataSubscriptionId()
                    else -> SubscriptionManager.getDefaultDataSubscriptionId()
                }.toLong()
            },
            isEsimEnabled = field {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    (context.getSystemService(Context.EUICC_SERVICE) as? EuiccManager)?.isEnabled
                } else {
                    null
                }
            },
        )
    }

    private fun subscription(info: SubscriptionInfo): AndroidSubscriptionMessage {
        val q = Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q
        return AndroidSubscriptionMessage(
            mobileCountryCode = field {
                @Suppress("DEPRECATION")
                if (q) info.mccString else info.mcc.takeIf { it > 0 }?.toString()
            },
            isOpportunistic = field { if (q) info.isOpportunistic else null },
            mobileNetworkCode = field {
                @Suppress("DEPRECATION")
                if (q) info.mncString else info.mnc.takeIf { it >= 0 }?.toString()?.padStart(2, '0')
            },
            displayName = field { info.displayName?.toString() },
            isNetworkRoaming = field { subscriptionManager?.isNetworkRoaming(info.subscriptionId) },
            simSlotIndex = field { info.simSlotIndex.toLong() },
            phoneNumber = field {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    subscriptionManager?.getPhoneNumber(info.subscriptionId)
                } else {
                    @Suppress("DEPRECATION")
                    info.number
                }
            },
            countryIso = field { info.countryIso },
            subscriptionType = field { if (q) info.subscriptionType.toLong() else null },
            cardId = field { if (q) info.cardId.toLong() else null },
            isEmbedded = field { if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) info.isEmbedded else null },
            carrierId = field { if (q) info.carrierId.toLong() else null },
            subscriptionId = field { info.subscriptionId.toLong() },
            simSerialNo = field {
                @Suppress("DEPRECATION")
                info.iccId
            },
            dataRoaming = field { info.dataRoaming.toLong() },
            portIndex = field {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) info.portIndex.toLong() else null
            },
        )
    }

    private suspend fun telephony(
        defaultTm: TelephonyManager,
        slot: Int,
        info: SubscriptionInfo?,
    ): AndroidTelephonyMessage {
        val subscriptionId = info?.subscriptionId ?: field {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                SubscriptionManager.getSubscriptionId(slot)
            } else {
                null
            }
        }?.takeIf { it != SubscriptionManager.INVALID_SUBSCRIPTION_ID }
        if (subscriptionId == null && slot > 0) {
            return AndroidTelephonyMessage(
                simSlotIndex = slot.toLong(),
                networkCountryIso = field {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) defaultTm.getNetworkCountryIso(slot) else null
                },
                simState = field {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) simState(defaultTm.getSimState(slot)) else null
                },
            )
        }
        val tm = subscriptionId?.let { id -> field { defaultTm.createForSubscriptionId(id) } } ?: defaultTm
        val simOperator = field { tm.simOperator }
        val displayNetworkType = displayNetworkType(tm)
        val networkGeneration = when (displayNetworkType) {
            "NR_NSA", "NR_ADVANCED" -> "5G"
            else -> field { networkGeneration(tm.dataNetworkType) }
        }

        return AndroidTelephonyMessage(
            simSlotIndex = slot.toLong(),
            networkCountryIso = field {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    defaultTm.getNetworkCountryIso(slot)
                } else {
                    tm.networkCountryIso
                }
            },
            mobileCountryCode = simOperator?.take(3),
            mobileNetworkCode = simOperator?.drop(3),
            displayName = field { tm.simOperatorName },
            simState = field {
                simState(
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) defaultTm.getSimState(slot) else tm.simState
                )
            },
            isoCountryCode = field { tm.simCountryIso },
            cellId = field { cellId(tm) },
            phoneNumber = field {
                @Suppress("DEPRECATION")
                tm.line1Number
            },
            carrierName = field { tm.simOperatorName },
            subscriptionId = subscriptionId?.toLong(),
            networkGeneration = networkGeneration,
            radioType = field { radioType(tm.dataNetworkType) },
            networkOperatorName = field { tm.networkOperatorName },
            networkOperator = field { tm.networkOperator },
            isNetworkRoaming = field { tm.isNetworkRoaming },
            simCarrierId = field {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) tm.simCarrierId.toLong() else null
            },
            simCarrierIdName = field {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) tm.simCarrierIdName?.toString() else null
            },
            signalLevel = field {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) tm.signalStrength?.level?.toLong() else null
            },
            signalDbm = field {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    tm.signalStrength?.cellSignalStrengths?.firstOrNull()?.dbm?.toLong()
                } else {
                    null
                }
            },
            displayNetworkType = displayNetworkType,
            isUsingNonTerrestrialNetwork = field {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.VANILLA_ICE_CREAM) {
                    tm.serviceState?.isUsingNonTerrestrialNetwork
                } else {
                    null
                }
            },
        )
    }

    /** The network type the status bar shows, which is how 5G NSA is reported as 5G instead of LTE. */
    private suspend fun displayNetworkType(tm: TelephonyManager): String? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return null
        val info = field {
            withTimeoutOrNull(DISPLAY_INFO_TIMEOUT_MS) {
                suspendCancellableCoroutine<TelephonyDisplayInfo> { continuation ->
                    val executor = Executor { it.run() }
                    val callback = object : TelephonyCallback(), TelephonyCallback.DisplayInfoListener {
                        override fun onDisplayInfoChanged(displayInfo: TelephonyDisplayInfo) {
                            tm.unregisterTelephonyCallback(this)
                            if (continuation.isActive) continuation.resume(displayInfo)
                        }
                    }
                    tm.registerTelephonyCallback(executor, callback)
                    continuation.invokeOnCancellation { tm.unregisterTelephonyCallback(callback) }
                }
            }
        } ?: return null

        return when (info.overrideNetworkType) {
            TelephonyDisplayInfo.OVERRIDE_NETWORK_TYPE_NONE -> "NONE"
            TelephonyDisplayInfo.OVERRIDE_NETWORK_TYPE_LTE_CA -> "LTE_CA"
            TelephonyDisplayInfo.OVERRIDE_NETWORK_TYPE_LTE_ADVANCED_PRO -> "LTE_ADVANCED_PRO"
            TelephonyDisplayInfo.OVERRIDE_NETWORK_TYPE_NR_NSA -> "NR_NSA"
            TelephonyDisplayInfo.OVERRIDE_NETWORK_TYPE_NR_ADVANCED -> "NR_ADVANCED"
            else -> null
        }
    }

    private fun radioType(networkType: Int): String = when (networkType) {
        TelephonyManager.NETWORK_TYPE_1xRTT -> "1xRTT"
        TelephonyManager.NETWORK_TYPE_CDMA -> "CDMA"
        TelephonyManager.NETWORK_TYPE_EDGE -> "EDGE"
        TelephonyManager.NETWORK_TYPE_EHRPD -> "eHRPD"
        TelephonyManager.NETWORK_TYPE_EVDO_0 -> "EVDO rev. 0"
        TelephonyManager.NETWORK_TYPE_EVDO_A -> "EVDO rev. A"
        TelephonyManager.NETWORK_TYPE_EVDO_B -> "EVDO rev. B"
        TelephonyManager.NETWORK_TYPE_GPRS -> "GPRS"
        TelephonyManager.NETWORK_TYPE_GSM -> "GSM"
        TelephonyManager.NETWORK_TYPE_HSDPA -> "HSDPA"
        TelephonyManager.NETWORK_TYPE_HSPA -> "HSPA"
        TelephonyManager.NETWORK_TYPE_HSPAP -> "HSPA+"
        TelephonyManager.NETWORK_TYPE_HSUPA -> "HSUPA"
        TelephonyManager.NETWORK_TYPE_IDEN -> "iDen"
        TelephonyManager.NETWORK_TYPE_UMTS -> "UMTS"
        TelephonyManager.NETWORK_TYPE_LTE -> "LTE"
        TelephonyManager.NETWORK_TYPE_NR -> "NR"
        TelephonyManager.NETWORK_TYPE_TD_SCDMA -> "TD SCDMA"
        TelephonyManager.NETWORK_TYPE_IWLAN -> "IWLAN"
        TelephonyManager.NETWORK_TYPE_UNKNOWN -> "Unknown"
        else -> ""
    }

    private fun networkGeneration(networkType: Int): String = when (networkType) {
        TelephonyManager.NETWORK_TYPE_GPRS,
        TelephonyManager.NETWORK_TYPE_EDGE,
        TelephonyManager.NETWORK_TYPE_CDMA,
        TelephonyManager.NETWORK_TYPE_1xRTT,
        TelephonyManager.NETWORK_TYPE_IDEN,
        TelephonyManager.NETWORK_TYPE_GSM -> "2G"
        TelephonyManager.NETWORK_TYPE_UMTS,
        TelephonyManager.NETWORK_TYPE_EVDO_0,
        TelephonyManager.NETWORK_TYPE_EVDO_A,
        TelephonyManager.NETWORK_TYPE_HSDPA,
        TelephonyManager.NETWORK_TYPE_HSUPA,
        TelephonyManager.NETWORK_TYPE_HSPA,
        TelephonyManager.NETWORK_TYPE_EVDO_B,
        TelephonyManager.NETWORK_TYPE_EHRPD,
        TelephonyManager.NETWORK_TYPE_HSPAP,
        TelephonyManager.NETWORK_TYPE_TD_SCDMA -> "3G"
        TelephonyManager.NETWORK_TYPE_LTE -> "4G"
        TelephonyManager.NETWORK_TYPE_NR -> "5G"
        else -> networkType.toString()
    }

    @androidx.annotation.RequiresApi(Build.VERSION_CODES.Q)
    private fun multiSimSupport(tm: TelephonyManager): String =
        when (tm.isMultiSimSupported) {
            TelephonyManager.MULTISIM_ALLOWED -> "MULTISIM_ALLOWED"
            TelephonyManager.MULTISIM_NOT_SUPPORTED_BY_CARRIER -> "MULTISIM_NOT_SUPPORTED_BY_CARRIER"
            TelephonyManager.MULTISIM_NOT_SUPPORTED_BY_HARDWARE -> "MULTISIM_NOT_SUPPORTED_BY_HARDWARE"
            else -> ""
        }

    private fun simState(state: Int): String = when (state) {
        TelephonyManager.SIM_STATE_ABSENT -> "SIM_STATE_ABSENT"
        TelephonyManager.SIM_STATE_CARD_IO_ERROR -> "SIM_STATE_CARD_IO_ERROR"
        TelephonyManager.SIM_STATE_CARD_RESTRICTED -> "SIM_STATE_CARD_RESTRICTED"
        TelephonyManager.SIM_STATE_NETWORK_LOCKED -> "SIM_STATE_NETWORK_LOCKED"
        TelephonyManager.SIM_STATE_NOT_READY -> "SIM_STATE_NOT_READY"
        TelephonyManager.SIM_STATE_PERM_DISABLED -> "SIM_STATE_PERM_DISABLED"
        TelephonyManager.SIM_STATE_PIN_REQUIRED -> "SIM_STATE_PIN_REQUIRED"
        TelephonyManager.SIM_STATE_PUK_REQUIRED -> "SIM_STATE_PUK_REQUIRED"
        TelephonyManager.SIM_STATE_READY -> "SIM_STATE_READY"
        TelephonyManager.SIM_STATE_UNKNOWN -> "SIM_STATE_UNKNOWN"
        else -> ""
    }

    private fun cellId(tm: TelephonyManager): CellIdMessage? {
        @Suppress("DEPRECATION")
        return when (val location = tm.cellLocation) {
            is GsmCellLocation -> CellIdMessage(cid = location.cid.toLong(), lac = location.lac.toLong())
            is CdmaCellLocation -> CellIdMessage(
                cid = location.baseStationId.toLong(),
                lac = location.networkId.toLong(),
            )
            else -> null
        }
    }
}
