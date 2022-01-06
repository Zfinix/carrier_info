package com.chizi.carrier_info


import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.telephony.TelephonyManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
/*import android.telephony.CellInfoLte
import android.telephony.CellInfoCdma
import android.telephony.CellInfoGsm*/
import android.telephony.cdma.CdmaCellLocation 
import android.telephony.gsm.GsmCellLocation 


internal class MethodCallHandlerImpl(context: Context, activity: Activity?) : MethodCallHandler {


    private val TAG: String =  "carrier_info"
    private var context: Context?
    private var activity: Activity?
    private val E_NO_CARRIER_NAME = "no_carrier_name"
    private val E_NO_NETWORK_TYPE = "no_network_type"
    private val E_NO_ISO_COUNTRY_CODE = "no_iso_country_code"
    private val E_NO_MOBILE_COUNTRY_CODE = "no_mobile_country_code"
    private val E_NO_MOBILE_NETWORK = "no_mobile_network"
    private val E_NO_NETWORK_OPERATOR = "no_network_operator"
    private val E_NO_CELL_ID = "no_cell_id"
    private var mTelephonyManager: TelephonyManager? = null
    private lateinit var func: () -> Unit?



    fun setActivity(act: Activity?) {
        this.activity = act
    }

    init {
        this.activity = activity
        this.context = context

        mTelephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Handler(Looper.getMainLooper()).post {
            when (call.method) {
                "carrierName" -> {
                    carrierName(result)
                }
                "isoCountryCode" -> {
                    isoCountryCode(result)
                }
                "mobileCountryCode" -> {
                    mobileCountryCode(result)
                }
                "mobileNetworkCode" -> {
                    mobileNetworkCode(result)
                }
                "mobileNetworkOperator" -> {
                    mobileNetworkOperator(result)
                }
                "radioType" -> {
                    func = { radioType(result) }
                    if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP_MR1) {
                        if (!checkIfAlreadyHavePermission()) {
                            requestForSpecificPermission(0)
                        }else{
                            radioType(result)
                        }
                    }
                }
                "networkGeneration" -> {
                    func = { networkGeneration(result) }
                    if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP_MR1) {
                        if (!checkIfAlreadyHavePermission()) {
                            requestForSpecificPermission(1)
                        }else{
                            networkGeneration(result)
                        }
                    }

                }
                "cellId" -> {
                    func = { cellId(result) }
                    if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP_MR1) {
                        if (!checkIfAlreadyHavePermission()) {
                            requestForSpecificPermission(2)
                        }else{
                            cellId(result)
                        }
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun requestForSpecificPermission(i: Int) {
        ActivityCompat.requestPermissions(this.activity!!, arrayOf(Manifest.permission.READ_PHONE_STATE, Manifest.permission.ACCESS_NETWORK_STATE, Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION), i)
    }

    private fun checkIfAlreadyHavePermission(): Boolean {
        return ContextCompat.checkSelfPermission(this.activity!!, Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED && 
        ContextCompat.checkSelfPermission(this.activity!!, Manifest.permission.ACCESS_NETWORK_STATE) == PackageManager.PERMISSION_GRANTED && 
        ContextCompat.checkSelfPermission(this.activity!!, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED &&
        ContextCompat.checkSelfPermission(this.activity!!, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
    }

    private fun carrierName(result: MethodChannel.Result) {
        val carrierName = mTelephonyManager!!.simOperatorName
        if (carrierName != null && "" != carrierName) {
            result.success(carrierName)
        } else {
            result.error(E_NO_CARRIER_NAME, "No carrier name","")
        }
    }

    private fun radioType(result: MethodChannel.Result) {
        when (mTelephonyManager!!.getDataNetworkType()) {
            TelephonyManager.NETWORK_TYPE_1xRTT -> result.success("1xRTT")
            TelephonyManager.NETWORK_TYPE_CDMA -> result.success("CDMA")
            TelephonyManager.NETWORK_TYPE_EDGE -> result.success("EDGE")
            TelephonyManager.NETWORK_TYPE_EHRPD -> result.success("eHRPD")
            TelephonyManager.NETWORK_TYPE_EVDO_0 ->result.success("EVDO rev. 0")
            TelephonyManager.NETWORK_TYPE_EVDO_A -> result.success("EVDO rev. A")
            TelephonyManager.NETWORK_TYPE_EVDO_B -> result.success("EVDO rev. B")
            TelephonyManager.NETWORK_TYPE_GPRS -> result.success("GPRS")
            TelephonyManager.NETWORK_TYPE_GSM -> result.success("GSM")
            TelephonyManager.NETWORK_TYPE_HSDPA -> result.success("HSDPA")
            TelephonyManager.NETWORK_TYPE_HSPA -> result.success("HSPA")
            TelephonyManager.NETWORK_TYPE_HSPAP -> result.success("HSPA+")
            TelephonyManager.NETWORK_TYPE_HSUPA -> result.success("HSUPA")
            TelephonyManager.NETWORK_TYPE_IDEN -> result.success("iDen")
            TelephonyManager.NETWORK_TYPE_UMTS -> result.success("UMTS")
            TelephonyManager.NETWORK_TYPE_LTE -> result.success("LTE")
            TelephonyManager.NETWORK_TYPE_NR -> result.success("NR")
            TelephonyManager.NETWORK_TYPE_TD_SCDMA -> result.success("TD SCDMA")
            TelephonyManager.NETWORK_TYPE_IWLAN -> result.success("IWLAN")
            TelephonyManager.NETWORK_TYPE_UNKNOWN -> result.success("Unknown")
        }
    }

    private fun networkGeneration(result: MethodChannel.Result) {
        val radioType = mTelephonyManager?.getDataNetworkType()
        if (radioType != null) {
            when (radioType) {
                TelephonyManager.NETWORK_TYPE_GPRS,
                TelephonyManager.NETWORK_TYPE_EDGE,
                TelephonyManager.NETWORK_TYPE_CDMA,
                TelephonyManager.NETWORK_TYPE_1xRTT,
                TelephonyManager.NETWORK_TYPE_IDEN,
                TelephonyManager.NETWORK_TYPE_GSM
                -> result.success("2G")
                TelephonyManager.NETWORK_TYPE_UMTS,
                TelephonyManager.NETWORK_TYPE_EVDO_0,
                TelephonyManager.NETWORK_TYPE_EVDO_A,
                TelephonyManager.NETWORK_TYPE_HSDPA,
                TelephonyManager.NETWORK_TYPE_HSUPA,
                TelephonyManager.NETWORK_TYPE_HSPA,
                TelephonyManager.NETWORK_TYPE_EVDO_B,
                TelephonyManager.NETWORK_TYPE_EHRPD,
                TelephonyManager.NETWORK_TYPE_HSPAP,
                TelephonyManager.NETWORK_TYPE_TD_SCDMA
                -> result.success("3G")
                TelephonyManager.NETWORK_TYPE_LTE
                -> result.success("4G")
                TelephonyManager.NETWORK_TYPE_NR
                -> result.success("5G")
                else -> result.success("Unknown")
                }

        } else {
            result.error(E_NO_NETWORK_TYPE, "No network type","")
        }
    }

    private fun isoCountryCode(result: MethodChannel.Result) {
        val iso = mTelephonyManager!!.simCountryIso
        if (iso != null && "" != iso) {
            result.success(iso)
        } else {
            result.error(E_NO_ISO_COUNTRY_CODE, "No iso country code","")
        }
    }

    // returns MCC (3 digits)

    private fun mobileCountryCode(result: MethodChannel.Result) {
        val plmn = mTelephonyManager!!.simOperator
        if (plmn != null && "" != plmn) {
            result.success(plmn.substring(0, 3))
        } else {
            result.error(E_NO_MOBILE_COUNTRY_CODE, "No mobile country code","")
        }
    }

    // returns MNC (2 or 3 digits)

    private fun mobileNetworkCode(result: MethodChannel.Result) {
        val plmn = mTelephonyManager!!.simOperator
        if (plmn != null && "" != plmn) {
            result.success(plmn.substring(3))
        } else {
            result.error(E_NO_MOBILE_NETWORK, "No mobile network code","")
        }
    }

    // return MCC + MNC (5 or 6 digits), e.g. 20601
    private fun mobileNetworkOperator(result: MethodChannel.Result){
        val plmn = mTelephonyManager!!.simOperator
        if (plmn != null && "" != plmn) {
            result.success(plmn)
        } else {
            result.error(E_NO_NETWORK_OPERATOR, "No mobile network operator", "")
        }
    }

    // return cell id
    private fun cellId(result: MethodChannel.Result){
        val location = mTelephonyManager!!.getCellLocation()
        if (location != null) {
            var cid = -1
            var lac = -1
            if (location is GsmCellLocation) {
                cid = (location as GsmCellLocation).getCid()
                lac = (location as GsmCellLocation).getLac()

            } else if(location is CdmaCellLocation){
                cid = (location as CdmaCellLocation).getBaseStationId()
                lac = (location as CdmaCellLocation).getNetworkId()
            }
            result.success(
                """
                {
                    "cid": $cid,
                    "lac": $lac
                }
                """
            )
            return
        }
        // FOLLOWING CODE WITH THE NEW API BUT DOES NOT WORK ON Android 11 AOSP //
        /*
        val cellInfos = mTelephonyManager!!.getAllCellInfo()
        if (cellInfos != null && cellInfos.size > 0) {
            val info = cellInfos[0]
            var cid = -1
            var lac = -1
            if (info is CellInfoGsm) {
                cid = (info as CellInfoGsm).getCellIdentity().getCid()
                lac = (info as CellInfoGsm).getCellIdentity().getLac()
            } else if(info is CellInfoCdma){
                cid = (info as CellInfoCdma).getCellIdentity().getBasestationId()
                lac = (info as CellInfoCdma).getCellIdentity().getNetworkId()
            } else if(info is CellInfoLte) {
                cid = (info as CellInfoLte).getCellIdentity().getCi()
            }
            result.success(
                """
                {
                    "cid": $cid,
                    "lac": $lac
                }
                """
            )
            return
        }
        */
        result.error(E_NO_CELL_ID, "No cell id", "")
    }


    fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?) {
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
