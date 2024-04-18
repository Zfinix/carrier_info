package com.chizi.carrier_info


import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.telephony.*
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler


internal class MethodCallHandlerImpl(context: Context, activity: Activity?) : MethodCallHandler {
    private val TAG: String = "carrier_info"
    private var context: Context?
    private var activity: Activity?
    private val E_NO_CARRIER_NAME = "no_carrier_name"
    private val E_NO_NETWORK_TYPE = "no_network_type"
    private val E_NO_ISO_COUNTRY_CODE = "no_iso_country_code"
    private val E_NO_MOBILE_COUNTRY_CODE = "no_mobile_country_code"
    private val E_NO_MOBILE_NETWORK = "no_mobile_network"
    private val E_NO_NETWORK_OPERATOR = "no_network_operator"
    private val E_NO_CELL_ID = "no_cell_id"
    private var mDefaultTelephonyManager: TelephonyManager? = null
    private lateinit var func: () -> Unit?


    fun setActivity(act: Activity?) {
        this.activity = act
    }

    init {
        this.activity = activity
        this.context = context

        // Retrieve the default subscription's TelephonyManager used for all calls"
       try {
           mDefaultTelephonyManager =
               context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
       } catch (e: Exception) {
           Log.e(TAG, e.toString())
       }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Handler(Looper.getMainLooper()).post {
            when (call.method) {
                "getAndroidInfo" -> {
                    try {
                        getInfo(result)
                    } catch (e: Exception) {
                        result.error(E_NO_CARRIER_NAME, "No carrier name", e.toString())
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }


    private fun requestForSpecificPermission(i: Int) {
        ActivityCompat.requestPermissions(
            this.activity!!,
            arrayOf(
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.ACCESS_NETWORK_STATE,
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.ACCESS_FINE_LOCATION
            ),
            i
        )
    }

    private fun checkIfAlreadyHavePermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this.activity!!,
            Manifest.permission.READ_PHONE_STATE
        ) == PackageManager.PERMISSION_GRANTED &&
                ContextCompat.checkSelfPermission(
                    this.activity!!,
                    Manifest.permission.ACCESS_NETWORK_STATE
                ) == PackageManager.PERMISSION_GRANTED &&
                ContextCompat.checkSelfPermission(
                    this.activity!!,
                    Manifest.permission.ACCESS_COARSE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED &&
                ContextCompat.checkSelfPermission(
                    this.activity!!,
                    Manifest.permission.ACCESS_FINE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED
    }


    private fun getInfo(result: MethodChannel.Result) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val telephonyList: ArrayList<HashMap<String, Any?>> = ArrayList()
            val subscriptionsList: ArrayList<HashMap<String, Any?>> = ArrayList()
            val subsManager =
                context!!.getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager

            if (subsManager.activeSubscriptionInfoList != null) {

                for (subsInfo in subsManager.activeSubscriptionInfoList) {
                    if (subsInfo != null) {
                        try {
                            val data = hashMapOf(
                                "simSerialNo" to subsInfo.iccId,
                                "mobileCountryCode" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) subsInfo.mccString else subsInfo.mcc.toString(),
                                "countryIso" to subsInfo.countryIso,
                                "mobileNetworkCode" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) subsInfo.mncString else subsInfo.mnc.toString(),
                                "cardId" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) subsInfo.cardId else null,
                                "carrierId" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) subsInfo.carrierId else null,
                                "dataRoaming" to subsInfo.dataRoaming,
                                "isEmbedded" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) subsInfo.isEmbedded else null,
                                "simSlotIndex" to subsInfo.simSlotIndex,
                                "subscriptionType" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) subsInfo.subscriptionType else null,
                                "isOpportunistic" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) subsInfo.isOpportunistic else null,
                                "displayName" to subsInfo.displayName,
                                "subscriptionId" to subsInfo.subscriptionId,
                                "phoneNumber" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
                                    subsManager.getPhoneNumber(subsInfo.subscriptionId) else subsInfo.number,
                                "isNetworkRoaming" to subsManager.isNetworkRoaming(subsInfo.subscriptionId),
                            )

                            subscriptionsList.add(data)
                        } catch (e: Exception) {
                            Log.d(
                                TAG,
                                "SubscriptionInfo Exception: ${subsInfo.carrierName}\n${e}"
                            )
                            subscriptionsList.add(HashMap())
                        }

                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                            val telephonyManager =
                                mDefaultTelephonyManager!!.createForSubscriptionId(subsInfo.subscriptionId);

                            try {
                                val data = hashMapOf<String, Any?>(
                                    "carrierName" to telephonyManager.simOperatorName,
                                    "dataActivity" to telephonyManager.dataActivity,
                                    "radioType" to radioType(telephonyManager),
                                    "cellId" to cellId(telephonyManager, subsInfo.simSlotIndex),
                                    "simState" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) simState(
                                        telephonyManager
                                    ) else null,
                                    "phoneNumber" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
                                        subsManager.getPhoneNumber(subsInfo.subscriptionId) else subsInfo.number,
                                    "networkOperatorName" to telephonyManager.networkOperatorName,
                                    "subscriptionId" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) telephonyManager.subscriptionId else null,
                                    "isoCountryCode" to telephonyManager.simCountryIso,
                                    "networkCountryIso" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) telephonyManager.networkCountryIso else null,
                                    "mobileNetworkCode" to if (telephonyManager.simOperator?.isEmpty() == false)
                                        telephonyManager.simOperator?.substring(3) else null,
                                    "displayName" to telephonyManager.simOperatorName,
                                    "mobileCountryCode" to if (telephonyManager.simOperator?.isEmpty() == false)
                                        telephonyManager.simOperator?.substring(0, 3) else null,
                                    "networkGeneration" to networkGeneration(telephonyManager),
                                )

                                telephonyList.add(data)
                            } catch (e: Exception) {
                                Log.d(
                                    TAG,
                                    "TelephonyManager Exception: ${telephonyManager.simOperatorName}\n${e}"
                                )
                                telephonyList.add(HashMap())
                            }
                        }
                    }
                }
            }

            val data = hashMapOf<String, Any?>(
                "isDataEnabled" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) mDefaultTelephonyManager!!.isDataEnabled else null,
                "isMultiSimSupported" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) isMultiSimSupported() else null,
                "isDataCapable" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) mDefaultTelephonyManager!!.isDataCapable else null,
                "isSmsCapable" to mDefaultTelephonyManager!!.isSmsCapable,
                "isVoiceCapable" to mDefaultTelephonyManager!!.isVoiceCapable,
                "telephonyInfo" to telephonyList,
                "subscriptionsInfo" to subscriptionsList,
            )

            result.success(data)
        } else {
            result.error(E_NO_CARRIER_NAME, "No carrier name", "")
        }


    }


    @RequiresApi(Build.VERSION_CODES.N)
    private fun radioType(telephonyManager: TelephonyManager): String {
        return when (telephonyManager.dataNetworkType) {
            TelephonyManager.NETWORK_TYPE_1xRTT -> return "1xRTT"
            TelephonyManager.NETWORK_TYPE_CDMA -> return "CDMA"
            TelephonyManager.NETWORK_TYPE_EDGE -> return "EDGE"
            TelephonyManager.NETWORK_TYPE_EHRPD -> return "eHRPD"
            TelephonyManager.NETWORK_TYPE_EVDO_0 -> return "EVDO rev. 0"
            TelephonyManager.NETWORK_TYPE_EVDO_A -> return "EVDO rev. A"
            TelephonyManager.NETWORK_TYPE_EVDO_B -> return "EVDO rev. B"
            TelephonyManager.NETWORK_TYPE_GPRS -> return "GPRS"
            TelephonyManager.NETWORK_TYPE_GSM -> return "GSM"
            TelephonyManager.NETWORK_TYPE_HSDPA -> return "HSDPA"
            TelephonyManager.NETWORK_TYPE_HSPA -> return "HSPA"
            TelephonyManager.NETWORK_TYPE_HSPAP -> return "HSPA+"
            TelephonyManager.NETWORK_TYPE_HSUPA -> return "HSUPA"
            TelephonyManager.NETWORK_TYPE_IDEN -> return "iDen"
            TelephonyManager.NETWORK_TYPE_UMTS -> return "UMTS"
            TelephonyManager.NETWORK_TYPE_LTE -> return "LTE"
            TelephonyManager.NETWORK_TYPE_NR -> return "NR"
            TelephonyManager.NETWORK_TYPE_TD_SCDMA -> return "TD SCDMA"
            TelephonyManager.NETWORK_TYPE_IWLAN -> return "IWLAN"
            TelephonyManager.NETWORK_TYPE_UNKNOWN -> return "Unknown"
            else -> ""
        }
    }


    @RequiresApi(Build.VERSION_CODES.Q)
    private fun isMultiSimSupported(): String {
        return when (mDefaultTelephonyManager!!.isMultiSimSupported) {
            TelephonyManager.MULTISIM_ALLOWED -> return "MULTISIM_ALLOWED"
            TelephonyManager.MULTISIM_NOT_SUPPORTED_BY_CARRIER -> return "MULTISIM_NOT_SUPPORTED_BY_CARRIER"
            TelephonyManager.MULTISIM_NOT_SUPPORTED_BY_HARDWARE -> return "MULTISIM_NOT_SUPPORTED_BY_HARDWARE"
            else -> ""
        }
    }


    @RequiresApi(Build.VERSION_CODES.O)
    private fun simState(telephonyManager: TelephonyManager): String {
        return when (telephonyManager.simState) {
            TelephonyManager.SIM_STATE_ABSENT -> return "SIM_STATE_ABSENT"
            TelephonyManager.SIM_STATE_CARD_IO_ERROR -> return "SIM_STATE_CARD_IO_ERROR"
            TelephonyManager.SIM_STATE_CARD_RESTRICTED -> return "SIM_STATE_CARD_RESTRICTED"
            TelephonyManager.SIM_STATE_NETWORK_LOCKED -> return "SIM_STATE_NETWORK_LOCKED"
            TelephonyManager.SIM_STATE_NOT_READY -> return "SIM_STATE_NOT_READY"
            TelephonyManager.SIM_STATE_PERM_DISABLED -> return "SIM_STATE_PERM_DISABLED"
            TelephonyManager.SIM_STATE_PIN_REQUIRED -> return "SIM_STATE_PIN_REQUIRED"
            TelephonyManager.SIM_STATE_PUK_REQUIRED -> return "SIM_STATE_PUK_REQUIRED"
            TelephonyManager.SIM_STATE_READY -> return "SIM_STATE_READY"
            TelephonyManager.SIM_STATE_UNKNOWN -> return "SIM_STATE_UNKNOWN"
            else -> ""
        }
    }

    @RequiresApi(Build.VERSION_CODES.N)
    private fun networkGeneration(telephonyManager: TelephonyManager): String {
        when (val radioType = telephonyManager.dataNetworkType) {
            TelephonyManager.NETWORK_TYPE_GPRS -> return "2G (GPRS)"
            TelephonyManager.NETWORK_TYPE_EDGE -> return "2G (EDGE)"
            TelephonyManager.NETWORK_TYPE_CDMA -> return "2G (CDMA)"
            TelephonyManager.NETWORK_TYPE_1xRTT -> return "2G (1xRTT)"
            TelephonyManager.NETWORK_TYPE_IDEN -> return "2G (IDEN)"
            TelephonyManager.NETWORK_TYPE_GSM -> return "2G (GSM)"

            TelephonyManager.NETWORK_TYPE_UMTS -> return "3G (UMTS)"
            TelephonyManager.NETWORK_TYPE_EVDO_0 -> return "3G (EVDO rev. 0)"
            TelephonyManager.NETWORK_TYPE_EVDO_A -> return "3G (EVDO rev. A)"
            TelephonyManager.NETWORK_TYPE_HSDPA -> return "3G (HSDPA)"
            TelephonyManager.NETWORK_TYPE_HSUPA -> return "3G (HSUPA)"
            TelephonyManager.NETWORK_TYPE_HSPA -> return "3G (HSPA)"
            TelephonyManager.NETWORK_TYPE_EVDO_B -> return "3G (EVDO rev. B)"
            TelephonyManager.NETWORK_TYPE_EHRPD -> return "3G (EHRPD)"
            TelephonyManager.NETWORK_TYPE_HSPAP -> return "3G (HSPA+)"
            TelephonyManager.NETWORK_TYPE_TD_SCDMA -> return "3G (TD-SCDMA)"

            TelephonyManager.NETWORK_TYPE_LTE -> return "4G (5G NSA)"

            TelephonyManager.NETWORK_TYPE_NR -> return "5G (5G SA)"

            TelephonyManager.NETWORK_TYPE_IWLAN -> return "IWLAN"

            TelephonyManager.NETWORK_TYPE_UNKNOWN -> return "Unknown"

            else -> radioType.toString()
        }

        return "unknown"
    }

    // return cell id
    private fun cellId(telephonyManager: TelephonyManager, slotIndex: Int): HashMap<String, Any>? {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            // registeredCellInfo elements are ordered, simSlot 0 information will be in the index 0
            val registeredCellInfo: ArrayList<CellInfo> = ArrayList()
            for (cellInfo in telephonyManager.allCellInfo) {
                if (cellInfo.isRegistered) {
                    registeredCellInfo.add(cellInfo)
                }
            }

            var cid = -1;
            var lac = -1;

            val currentCellInfo = registeredCellInfo[slotIndex]

            if (currentCellInfo is CellInfoGsm) {
                val identityGsm = currentCellInfo.cellIdentity
                cid = identityGsm.cid
                lac = identityGsm.lac
            } else if (currentCellInfo is CellInfoCdma) {
                val identityCdma = currentCellInfo.cellIdentity
                cid = identityCdma.basestationId
                lac = identityCdma.networkId
            } else if (currentCellInfo is CellInfoLte) {
                val identityLte = currentCellInfo.cellIdentity
                cid = identityLte.ci
                lac = identityLte.tac
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2 && currentCellInfo is CellInfoWcdma) {
                val identityWcdma = currentCellInfo.cellIdentity
                cid = identityWcdma.cid
                lac = identityWcdma.lac
            }

            return hashMapOf("cid" to cid, "lac" to lac)
        }

        return null;
    }


    fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>?,
        grantResults: IntArray?
    ) {
        when (requestCode) {
            0 -> return if (grantResults!![0] == PackageManager.PERMISSION_GRANTED) {
                this.func()!!

            } else {
                requestForSpecificPermission(0)

            }

            1 -> return if (grantResults!![0] == PackageManager.PERMISSION_GRANTED) {
                this.func()!!

            } else {
                requestForSpecificPermission(1)

            }

            2 -> return if (grantResults!![0] == PackageManager.PERMISSION_GRANTED) {
                this.func()!!

            } else {
                requestForSpecificPermission(2)
            }
        }
    }
}

