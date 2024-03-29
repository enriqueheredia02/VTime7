﻿<%@ Page Language="VB" explicit="true" Inherits="InMotionGIT.Web.Page.BackOfficeCommon" EnableViewState="false"%>
<%@ Import namespace="eFunctions" %>
<%@ Import namespace="eProduct" %>
<%@ Import namespace="eBranches" %>
<%@ Import namespace="ePolicy" %>
<script language="VB" runat="Server">

    '- Objeto para el manejo de funciones generales
    Dim mobjValues As eFunctions.Values

    '- Variable para el manejo del querystring
    Dim mstrQueryString As String

    '- Se define la constante para el manejo de errores en caso de advertencias

    Dim mstrCommand As String

    Dim mstrErrors As Object
    Dim mobjProductSeq As Object
    Dim mobjClient_req As eProduct.Client_req
    Dim mstrLocationBC003 As String
    '- Contador para uso general    
    Dim mintCount As Integer

    '- Esta variable es para indicar cuando debe pasarse a la siguiente ventana de la secuencia
    '- al aceptar.  Para uso de casos particulares.
    Dim lstrGoToNext As String

    '- Cadena para pase de parametros    
    Dim mstrString As String


    '% insvalSequence: Se realizan las validaciones masivas de la forma
    '--------------------------------------------------------------------------------------------
    Function insvalSequence() As Object
        Dim lblnRequired As Boolean
        Dim nStatregt As Object
        Dim nStatus As Object
        Dim lstrAction As String
        Dim lintIndex3 As Integer
        Dim nAction As Object
        '--------------------------------------------------------------------------------------------
        insvalSequence = vbNullString

        Dim lclsTab_Clause As eProduct.Tab_Clause
        Dim lclsProd_reserve As eProduct.Prod_reserve
        Dim mobjCur_allow As eProduct.Cur_Allow
        Dim lclsCliallocla As eProduct.Cliallocla
        Dim lobjErrors As eFunctions.Errors
        Dim lclsTar_am_Basprod As eBranches.Tar_am_basprod
        Dim lclsTab_am_excprod As eBranches.Tab_am_excprod
        Dim lclsTab_am_cli As eBranches.Tab_am_cli
        Dim lclsLimits_age As eBranches.Limits_age
        Dim lclsPay_fracti As ePolicy.Pay_Fracti
        Dim lclsNull_condi As eProduct.Null_condi
        Dim lclsBas_sumins As eProduct.Bas_sumins
        Dim lclsProduct As eProduct.Product
        Dim lclsLife_load As eProduct.Life_load

        'NS: CACHE 
        'If Not IsNothing(Session("nProduct")) AndAlso
        '   Not IsNothing(Session("nProduct")) Then
        '    InMotionGIT.Common.Helpers.Caching.Remove(String.Format("ProductMaster_{0}_{1}", Session("nBranch"), Session("nProduct")))
        'End If

        Select Case Request.QueryString.Item("sCodispl")

            '+ DP003_K: Características de los productos
            Case "DP003_K"
                mobjProductSeq = New eProduct.Product
                With Request
                    With Request
                        insvalSequence = mobjProductSeq.insValDP003_K("DP003_K", mobjValues.StringToType(Request.QueryString.Item("nMainAction"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcdEffecdate"), eFunctions.Values.eTypeData.etdDate), .Form.Item("cbeProdType"))
                    End With
                End With

                '+ DP003: Información general
            Case "DP003"
                mobjProductSeq = New eProduct.Product
                With Request
                    insvalSequence = mobjProductSeq.insValDP003(.QueryString("sCodispl"), mobjValues.StringToType(.QueryString.Item("nMainAction"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("cbeStatus"), mobjValues.StringToType(.Form.Item("chkSimulator"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("valDeclarative"), .Form.Item("tctDescript"), .Form.Item("tctShortDes"), mobjValues.StringToType(.Form.Item("tcnReference"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("tcnVersion"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("chkIndividual"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("chkGroups"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("chkMulti"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeTypeHeap"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeReinHeap"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnCurrencyQ"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctPreffix"), .Form.Item("chkAssociated_Policy_Required"), mobjValues.StringToType(.Form.Item("cbeAssociatedBranch"), eFunctions.Values.eTypeData.etdInteger) )
                End With

                '+ DP004: Campos requeridos en la emisión
            Case "DP004"
                insvalSequence = vbNullString

                '+ DP005: Respuestas Automáticas en la Emisión 
            Case "DP005"
                mobjProductSeq = New eProduct.Product
                With Request
                    insvalSequence = mobjProductSeq.insValDP005("DP005", mobjValues.StringToType(.Form.Item("tcnCopy"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnTime"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeTypepolicy"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctIndivind"), .Form.Item("tctGroupind"), .Form.Item("tctMultiind"), mobjValues.StringToType(.Form.Item("cbePayfrequen"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnQuotas"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeReinsuran"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeRevalform"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeRevalType"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnrevalfactor"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeInvocehold"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeGrouprenew"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbePremium"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeTaxes"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeCommission"), eFunctions.Values.eTypeData.etdDouble))
                End With

                '+ DP008: Recargos y descuentos
            Case "DP008"
                mobjProductSeq = New eProduct.Disco_expr

                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.insValDP008Upd(mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("tcnCode"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("cbeType"), .Form.Item("tctDescript"), .Form.Item("tctShort_des"), mobjValues.StringToType(.Form.Item("tcnOrder_apl"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("cbeStatregt"), .Form.Item("tctOldStatregt"), mobjValues.StringToType(.Form.Item("tcnExist"), eFunctions.Values.eTypeData.etdDouble))

                    Else
                        If Request.QueryString.Item("nMainAction") <> CStr(eFunctions.Menues.TypeActions.clngActionQuery) Then
                            insvalSequence = mobjProductSeq.insValDP008(mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate))
                        End If
                    End If
                End With

                '+ DP578: Vías de pago permitidas
            Case "DP578"
                mobjProductSeq = New eProduct.Way_pay_prod
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.insValDP578(.QueryString("sCodispl"), .QueryString("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeWay_pay"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("tcnRate_ex"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnRate_disc"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("chkPrem_first"), mobjValues.StringToType(.Form.Item("tcnNull_day"), eFunctions.Values.eTypeData.etdDouble))

                    End If
                End With

                '+ DP578A: Vías de pago permitidas
            Case "DP578A"
                mobjProductSeq = New eProduct.Freq_way_prod
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        mstrQueryString = "&nWay_pay=" & Request.QueryString.Item("nWay_pay")
                        insvalSequence = mobjProductSeq.insValDP578(.QueryString("sCodispl"), .QueryString("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnWay_pay"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbePayFreq"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("cbeCurrency"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPre_issue"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPre_amend"), eFunctions.Values.eTypeData.etdDouble))

                    End If
                End With

                '+ DP027: Criterios técnicos - Selección de riesgo.
            Case "DP027"
                mobjProductSeq = New eProduct.Life_speci

                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.insValDP027("DP027", mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), .Form.Item("sSexinsur"), mobjValues.StringToType(.Form.Item("nAgestart"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("nAgeend"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("nCapstart"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("nCapend"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("nCrthecni"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("nConsec"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbenModule"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbenCover"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeRole"), eFunctions.Values.eTypeData.etdLong))
                    End If
                End With

                '+ DP101: Conceptos de pago por producto
            Case "DP101"
                mobjProductSeq = New eProduct.Prod_Am_Bil

                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then

                        insvalSequence = mobjProductSeq.insValDP101("DP101", Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("cbenModulec"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("cbenCover"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("cbenRole"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("tcnGroup_Pres"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("tcnPay_Concep"), eFunctions.Values.eTypeData.etdLong), .Form.Item("valIllness"), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("cbenCurrency"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("tcnDed_Type"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("tcnDed_Amount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnDed_Percen"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnDed_Quanti"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnIndem_rate"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnLimit"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnTypLim"), eFunctions.Values.eTypeData.etdLong, True), mobjValues.StringToType(.Form.Item("tcnCount"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("tcnLimit_exe"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPunish"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("tcnDed_Quanti_2"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnIndem_Rate_2"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnLimit_2"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnTypLim_2"), eFunctions.Values.eTypeData.etdLong, True), mobjValues.StringToType(.Form.Item("tcnCount_2"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("tcnLimit_exe_2"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPunish_2"), eFunctions.Values.eTypeData.etdDouble))
                    End If
                End With


                '+ DP809: Reportes automaticos para productos.
            Case "DP809"
                mobjProductSeq = New eProduct.report_prod
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.insValDP809(Request.QueryString("Action"), _
                                                                    mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), _
                                                                    mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), _
                                                                    mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), _
                                                                    "DP809", _
                                                                    Request.Form("valCodispl"), _
                                                                    mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), _
                                                                    mobjValues.StringToType(Request.Form("cbeTransaction"), eFunctions.Values.eTypeData.etdLong), _
                                                                    mobjValues.StringToType(Request.Form("cbeReptype"), eFunctions.Values.eTypeData.etdLong), _
                                                                    Request.Form("tctReport"))
                    End If
                End With

                '+ DP031: Características Particulares de Ramos Generales
            Case "DP031"
                mobjProductSeq = New eProduct.Product_ge
                With Request
                    insvalSequence = mobjProductSeq.insValDP031("DP031", mobjValues.StringToType(.Form.Item("chkResmaypa"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnLevelpay"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("optDamage"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cboPayconre"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnClaimpres"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cboCurrency"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("optNoAplied"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPreissue"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnFrancRat"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPre_amend"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnFix"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("optCapApl"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnFrancMin"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnFrancmax"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("chkSuspendi"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnClaimNotice"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnClaimPay"), eFunctions.Values.eTypeData.etdDouble))
                End With

                '+ DP033: Coberturas de un módulo o producto 
            Case "DP033"
                With Request
                    mobjProductSeq = New eProduct.Gen_cover
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.insvalDP033(.QueryString("WindowType"), .Form.Item("tcnCount"), .QueryString("Action"), Session("nBranch"), Session("nProduct"), Session("dEffecdate"), Session("sBrancht"), mobjValues.StringToType(.Form.Item("tcnModulec"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("nCover"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("nCovergen"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("sStatregt"))
                    Else
                        insvalSequence = mobjProductSeq.insvalDP033(.QueryString("WindowType"), .Form.Item("tcnCount"), .QueryString("Action"), Session("nBranch"), Session("nProduct"), Session("dEffecdate"), Session("sBrancht"), mobjValues.StringToType(.Form.Item("cbeModulec"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("nCover"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("nCovergen"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("sStatregt"))
                    End If
                End With

                '+ DP036: Elementos de Protección 
            Case "DP036"
                mobjProductSeq = New eProduct.Product
                With Request
                    If Request.QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.insValDP036(mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("tcnElement"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctElementDescription"), .Form.Item("tctShortDescription"), mobjValues.StringToType(.Form.Item("cbeState"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeCurrency"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnMaxAmount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnMinAmount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnInitialSelection"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnFixAmount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnFixAmount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnDisrate"), eFunctions.Values.eTypeData.etdDouble))
                    End If
                End With

                '+ DP037: Tabla de Corto Plazo
            Case "DP037"
                mobjProductSeq = New eProduct.Tab_short
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.insValDP037(.QueryString("Action"), Session("nBranch"), Session("nProduct"), mobjValues.StringToType(.Form.Item("tcnMonthMax"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnDaysMax"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnRatePremium"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnRateDevolution"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate))
                    End If
                End With

                '+ DP038: Requisitos y exclusiones
            Case "DP038"
                mobjProductSeq = New eProduct.Tab_reqexc
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.insValDP038Upd(Request.QueryString.Item("Action"), Request.QueryString.Item("sCodispl"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), Session("sBrancht"), mobjValues.StringToType(.Form.Item("tctRelation"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tctType1"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tctElement1"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("valRole1"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tctType2"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tctElement2"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("valRole2"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("hddDefReq"), eFunctions.Values.eTypeData.etdLong))
                    Else
                        insvalSequence = mobjProductSeq.insValDP038(Request.QueryString.Item("sCodspl"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate))
                    End If
                End With

                '+ DP042: Clientes Permitidos
            Case "DP042"

                mobjProductSeq = New eProduct.Product

                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.insValDP042("DP042", mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), .Form.Item("tctPoliType"), .Form.Item("tcnIndividual"), .Form.Item("tcnColectiva"), .Form.Item("tcnMultilocalidad"), .Form.Item("sRequired"), CStr(.Form.Item("tcnChecked")), mobjValues.StringToType(.Form.Item("tcnCounter"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("sDefault"), .Form.Item("tcnMaxValue"))
                    Else

                        insvalSequence = mobjProductSeq.insValDP042("DP042", mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), .Form.Item("OptPolicyType"), vbNullString, vbNullString, vbNullString, vbNullString, vbNullString, 0, vbNullString, 1, True)
                    End If
                End With

                '+ DP011: Conceptos de facturación
            Case "DP011"
                mobjProductSeq = New eProduct.Tab_bill_i
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.insValDP011(.QueryString("Action"), Session("nBranch"), Session("nProduct"), Session("dEffecdate"), mobjValues.StringToType(.Form.Item("tcnBill_item"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctDescript"), .Form.Item("tctShort_des"))
                    End If
                End With

                '+ DP032: Módulos de un producto 
            Case "DP032"
                mobjProductSeq = New eProduct.Tab_modul
                With Request
                    insvalSequence = mobjProductSeq.insValDP032(.QueryString("WindowType"), .QueryString("Action"), mobjValues.StringToType(.Form.Item("hddCountRecord"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnModulec"), eFunctions.Values.eTypeData.etdDouble, True), .Form.Item("tctDescript"), .Form.Item("tctShort_des"), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), .Form.Item("chkRequire"), .Form.Item("chkDefaulti"), .Form.Item("chkChanallo"), mobjValues.StringToType(.Form.Item("tcnPremirat"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnchprelev"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnRatepreadd"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnRatepresub"), eFunctions.Values.eTypeData.etdDouble, True), .Form.Item("chkStyp_rat"), .Form.Item("chkStyp_rat"))
                End With

                '+ DP009: Cláusula/Descriptivo/Condición Especial
            Case "DP009"
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lclsTab_Clause = New eProduct.Tab_Clause
                        insvalSequence = lclsTab_Clause.insValDP009("DP009", mobjValues.StringToType(.Form.Item("tcnClause"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctDescript"), .Form.Item("tctShort_des"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToDate(Session("dEffecdate")), mobjValues.StringToType(.Form.Item("valModulec"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valCover"), eFunctions.Values.eTypeData.etdDouble), Request.QueryString.Item("Action"), mobjValues.StringToType(.Form.Item("cbeType"), eFunctions.Values.eTypeData.etdLong, True))
                        lclsTab_Clause = Nothing
                    End If
                End With

                '+ DP201: Reserva por producto

            Case "DP201"
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lclsProd_reserve = New eProduct.Prod_reserve
                        insvalSequence = lclsProd_reserve.insValDP210(.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeType_reserve"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valModulec"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valCover"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToDate(Session("dEffecdate")), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctRoureser"))
                        lclsProd_reserve = Nothing
                    End If
                End With

                '+ DP055: Monedas permitidas para la póliza.
            Case "DP055"
                mobjCur_allow = New eProduct.Cur_Allow
                With Request
                    Dim nPreSelCount As Integer
                    Dim nSelCount As Integer
                    Try
                        nSelCount = Request.Form.GetValues("Sel").Count
                    Catch
                        nSelCount = 0
                    End Try

                    Try
                        nPreSelCount = Request.Form.GetValues("tctPreSelection").Count
                    Catch
                        nPreSelCount = 0
                    End Try

                    insvalSequence = mobjCur_allow.insValDP055(Request.QueryString.Item("sCodispl"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), nSelCount, nPreSelCount, .Form.Item("hSel"), .Form.Item("hCodigint"))

                End With
                mobjCur_allow = Nothing

                '+ DP056: Clientes Permitidos en un Siniestro
            Case "DP056"
                lclsCliallocla = New eProduct.Cliallocla
                With Request
                    If .Form.Item("tcnAuxRole").Length > 1 Then
                        For lintIndex3 = 0 To .Form.GetValues("tcnAuxRole").Count - 1
                            If CDbl(.Form.GetValues("sAuxSel").GetValue(lintIndex3)) <> 1 Then
                                lblnRequired = False
                            Else
                                '+ Existe al menos una figura marcada 
                                lblnRequired = True
                                Exit For
                            End If
                        Next
                        For lintIndex3 = 0 To .Form.GetValues("tcnAuxRole").Count - 1
                            If CDbl(.Form.GetValues("sAuxSel").GetValue(lintIndex3)) = 1 Or CDbl(.Form.GetValues("chkAuxExist").GetValue(lintIndex3)) = 1 Or .Form.GetValues("chkAuxRequire").GetValue(lintIndex3) = "1" Then
                                insvalSequence = lclsCliallocla.insValDP056("DP056", .Form.GetValues("sAuxSel").GetValue(lintIndex3), .Form.GetValues("chkAuxRequire").GetValue(lintIndex3), .Form.GetValues("chkAuxExist").GetValue(lintIndex3), CShort(lintIndex3))
                            End If
                        Next
                        If Not lblnRequired Then
                            lobjErrors = New eFunctions.Errors
                            Call lobjErrors.ErrorMessage("DP056", 11181)
                            insvalSequence = lobjErrors.Confirm
                            lobjErrors = Nothing
                        End If
                    End If
                    lclsCliallocla = Nothing
                End With

                '+ DP057: Tarifas de atención médica
            Case "DP057"
                lclsTar_am_Basprod = New eBranches.Tar_am_basprod
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        'ByVal sCodispl ,            ByVal sAction As String,                   ByVal nBranch As Integer,                                                           ByVal nProduct As Integer,                                                                ByVal nTariff As Integer,                                                                ByVal nBenef_type As Integer,                                         ByVal sDefaulti As String,                       ByVal nAge_init As Integer,                                                               ByVal nAge_end As Integer,                                                                ByVal nGroup_comp As Integer,                                                              ByVal dEffecdate As Date,                                                               ByVal nLimit As Double,                                                                   ByVal nDed_amount As Double,                                                                 ByVal nPremium As Double,                                                ByVal sWindows As String,                        ByVal nModulec As Integer,                                                                 ByVal nCover As Integer)
                        insvalSequence = lclsTar_am_Basprod.insValDP057("DP057", Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("hddTariff"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("hddBenef_Type"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("hddDefaulti"), mobjValues.StringToType(.Form.Item("tcnAgeInit"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnAgeEnd"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnComp_group"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("hddLimit"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("hddDeduc_amount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPremium"), eFunctions.Values.eTypeData.etdDouble), .QueryString.Item("WindowType"), mobjValues.StringToType(.Form.Item("hddModulec"), eFunctions.Values.eTypeData.etdInteger), mobjValues.StringToType(.Form.Item("hddCover"), eFunctions.Values.eTypeData.etdInteger))
                    Else
                        insvalSequence = lclsTar_am_Basprod.insValDP057("DP057", Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnTariff"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeBenefType"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("chkDefaulti"), 0, 0, 0, mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("tcnLimit"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnDed_amount"), eFunctions.Values.eTypeData.etdDouble), 0, .QueryString.Item("WindowType"), mobjValues.StringToType(.Form.Item("cbeModulec"), eFunctions.Values.eTypeData.etdInteger), mobjValues.StringToType(.Form.Item("tcnCover"), eFunctions.Values.eTypeData.etdInteger))
                    End If
                    lclsTar_am_Basprod = Nothing

                End With

                '+ DP058: Exclusión de enfermedades
            Case "DP058"
                If Request.QueryString.Item("WindowType") = "PopUp" Then
                    lclsTab_am_excprod = New eBranches.Tab_am_excprod

                    insvalSequence = lclsTab_am_excprod.insValDP058("DP058", Request.QueryString.Item("Action"), mobjValues.StringToType(Request.Form.Item("nTariff"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), Request.Form.Item("cbeDescript"), mobjValues.StringToType(Request.Form.Item("tcdInit_date"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Request.Form.Item("tcdEnd_date"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Request.Form.Item("cbeExc_code"), eFunctions.Values.eTypeData.etdDouble), Request.Form.Item("sType_Excl"))


                    lclsTab_am_excprod = Nothing
                End If




                '+ DP059: Clínicas
            Case "DP059"

                If Request.QueryString.Item("WindowType") = "PopUp" Then
                    lclsTab_am_cli = New eBranches.Tab_am_cli
                    insvalSequence = lclsTab_am_cli.insValDP059("DP059", Request.QueryString.Item("Action"), mobjValues.StringToType(Request.Form.Item("cbeHospital"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate))
                    lclsTab_am_cli = Nothing
                End If

                '+ Edades límites de asegurados
            Case "DP060"
                If Request.QueryString.Item("WindowType") = "PopUp" Then
                    lclsLimits_age = New eBranches.Limits_age
                    insvalSequence = lclsLimits_age.insValDP060("DP060", Request.QueryString.Item("Action"), mobjValues.StringToType(Request.Form.Item("cbeRelation"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnAge"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate))
                    lclsBas_sumins = Nothing
                End If


                '+ DP010: Frecuencia de Pagos Permitidos            
            Case "DP010"

                If Request.QueryString.Item("WindowType") = "PopUp" Then
                    lclsPay_fracti = New ePolicy.Pay_Fracti

                    If Request.QueryString.Item("Action") <> "Del" Then
                        nAction = 1
                        Select Case Request.QueryString.Item("Action")
                            Case "Add"
                                nStatus = 1
                                nStatregt = 2
                                lstrAction = "Add"
                            Case "Update"
                                nStatus = 2
                                nStatregt = Request.Form.Item("cboAuxStatregt")
                                lstrAction = "Update"
                        End Select
                    End If

                    insvalSequence = lclsPay_fracti.insValDP010_Upd(mobjValues.StringToType(nAction, eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("cboPay_fracti"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnQuota"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnRatepayf"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("cboStatregt"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(nStatregt, eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(nStatus, eFunctions.Values.eTypeData.etdDouble), lstrAction)
                    lclsPay_fracti = Nothing
                End If

                '+ DP061: Condiciones de anulación
            Case "DP061"

                lclsNull_condi = New eProduct.Null_condi

                insvalSequence = lclsNull_condi.insValDP061("DP061", Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToDate(Session("dEffecdate")), mobjValues.StringToType(Request.Form.Item("cboNullcode"), eFunctions.Values.eTypeData.etdDouble), CStr(Request.Form.Item("cboReturn_ind")), mobjValues.StringToType(Request.Form.Item("tcnReturn_rat"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnAmelevel"), eFunctions.Values.eTypeData.etdDouble), Request.Form.Item("chkNotRehab"), Request.Form.Item("tctRoutine_Pay"), mobjValues.StringToType(Request.Form.Item("tcnRetraction"), eFunctions.Values.eTypeData.etdDouble))
                lclsNull_condi = Nothing

                '+ DP062: Capitales Básicos
            Case "DP062"
                lclsBas_sumins = New eProduct.Bas_sumins

                insvalSequence = lclsBas_sumins.insValDP062("DP062", Request.Form.Item("tctDescript"), Request.Form.Item("tctShort_des"), mobjValues.StringToType(Request.Form.Item("nCountReg"), eFunctions.Values.eTypeData.etdDouble), Request.QueryString.Item("WindowType"))

                lclsBas_sumins = Nothing

                '+ DP999: Fin de proceso.
            Case "DP999"
                lclsProduct = New eProduct.Product
                insvalSequence = lclsProduct.insExecuteDP999(mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), CShort(Request.Form.Item("cboStatProduct")))

                '+ DP023: Datos del Colectivo
            Case "DP023"
                mobjProductSeq = New eProduct.Product
                With Request
                    insvalSequence = mobjProductSeq.insValDP023("DP023", .Form.Item("chkUseGroups"), mobjValues.StringToType(.Form.Item("tcnMaxInsured"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnMinInsured"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("cbeReceiptType"), .Form.Item("cbeCoverType"), .Form.Item("cbeXpremType"), .Form.Item("cbeClauseType"))
                End With

                '+ DP012: Secuencia para el tratamiento de pòliza
            Case "DP012"
                Dim nSelLength As Integer
                If IsNothing(Request.Form.Item("Sel")) Then
                    nSelLength = 0
                Else
                    nSelLength = Request.Form.Item("Sel").Length
                End If
                mobjProductSeq = New eProduct.Sequen_pol
                insvalSequence = mobjProductSeq.insValDP012(Session("nBranch"), Session("nProduct"), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), nSelLength, Request.Form.Item("hddMassive"))

                '+ DP048: Secciones a incluir en el cuadro de pólizas
            Case "DP048"
                With Request
                    mobjProductSeq = New eProduct.Section_po
                    insvalSequence = ""
                End With

                '+ DP041: Descuento por Siniestralidad
            Case "DP041"
                mobjProductSeq = New eProduct.Tar_au_bon
                With Request
                    insvalSequence = mobjProductSeq.insValDP041(Request.QueryString.Item("WindowType"), Request.QueryString.Item("Action"), "DP041", .Form.Item("hddCountRecord"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("tcnYear"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnClaimrat"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnDiscount"), eFunctions.Values.eTypeData.etdDouble, True))
                End With

                '+ DP100: Bienes asegurados permitidos
            Case "DP100"
                mobjProductSeq = New ePolicy.Tab_goods
                With Request
                    If .QueryString.Item("WindowType") <> "PopUp" Then

                        insvalSequence = mobjProductSeq.insValDP100("DP100", mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), , , , , , , , "Normal", .QueryString("Action"))
                    Else
                        insvalSequence = mobjProductSeq.insValDP100("DP100", mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnCode_good"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctDescript"), .Form.Item("tctShort_des"), mobjValues.StringToType(.Form.Item("tcnRate"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnRatChaAdd"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnRatChaSub"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnLevelCha"), eFunctions.Values.eTypeData.etdDouble), "PopUp", .QueryString("Action"))
                    End If
                End With


                '+ DP102: Tipos de desglose
            Case "DP102"
                mobjProductSeq = New ePolicy.Detailsallowed
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.insValDP102("DP102", mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeType"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnCode_good"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctDescript_Good"), mobjValues.StringToType(.Form.Item("cbeAddCapital"), eFunctions.Values.eTypeData.etdDouble), Session("dEffecdate"), "PopUp", .QueryString("Action"))
                    End If
                End With

                '+ DP043: Carasterísticas de vida I
            Case "DP043"
                mobjProductSeq = New eProduct.ProdLifeSeq
                With Request
                    If .QueryString.Item("WindowType") <> "PopUp" Then
                        insvalSequence = mobjProductSeq.insValDP043("DP043", mobjValues.StringToType(.Form.Item("cbeProdclas"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeCurrency"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("optIdurvari"), mobjValues.StringToType(.Form.Item("hddRecordCountS"), eFunctions.Values.eTypeData.etdDouble, True), .Form.Item("optIpayvari"), mobjValues.StringToType(.Form.Item("hddRecordCountP"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("cbeTypdurins"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("nQMonVPN"), eFunctions.Values.eTypeData.etdDouble))
                    Else
                        '+ Se realizan las validaciones sobre la grilla de duraciones del seguro
                        If Request.QueryString.Item("sArrayName") = "Durinsu" Then
                            mobjProductSeq = New eProduct.Durinsu_prod
                            insvalSequence = mobjProductSeq.insValDP043UPD("DP043", Request.QueryString.Item("Action"), Session("nBranch"), Session("nProduct"), mobjValues.StringToType(.Form.Item("tcnIdurafix"), eFunctions.Values.eTypeData.etdDouble, True), .Form.Item("optIpayvari"), Session("dEffecdate"), mobjValues.StringToType(.Form.Item("cbeTypeInsur1"), eFunctions.Values.eTypeData.etdDouble, True))
                        Else
                            '+ Se realizan las validaciones sobre la grilla de duraciones de los pagos
                            mobjProductSeq = New eProduct.Durpay_prod
                            insvalSequence = mobjProductSeq.insValDP043UPD("DP043", Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("optIdurvari"), mobjValues.StringToType(.Form.Item("cbeIdurafix"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnPdurafix"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("cbeTypeInsur"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("cbeTypePay"), eFunctions.Values.eTypeData.etdDouble, True))
                        End If
                    End If
                End With

                '+ DP705: Tipos de asegurados por cobertura
            Case "DP705"
                insvalSequence = vbNullString

                '+ DP607: Condiciones generales de productos de VidActiva
            Case "DP607"
                mobjProductSeq = New eProduct.Tab_ActiveLife
                With Request
                    insvalSequence = mobjProductSeq.insValDP607("DP607", mobjValues.StringToType(.QueryString.Item("nMainAction"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPremMin"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnQMonVPN"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnQMonToVPN"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnRateReh"), eFunctions.Values.eTypeData.etdDouble, True))
                End With

                '**+ DP064: Charges over deposits and current accounts
                '+ DP064: Cargos sobre aportes y cuentas corrientes
                '+ [APV2] HAD 1021 – Cambios en la lógica de descuento de los costos coberturas. DBLANCO 03-09-2003

            Case "DP064"

                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lclsLife_load = New eProduct.Life_load
                        insvalSequence = lclsLife_load.insValDP064(.QueryString.Item("sCodispl"), .QueryString.Item("Action"), 1, mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnLoad_cod"), eFunctions.Values.eTypeData.etdDouble), Session("dEffecdate"), .Form.Item("tctDescript"), mobjValues.StringToType(.Form.Item("cbeLoad_type"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnLoadAmo"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnLoadRate"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("cbeStatregt"), .Form.Item("tctShort_des"), mobjValues.StringToType(.Form.Item("cbePayFreq"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctRoutine"), .Form.Item("chkPreInv"), mobjValues.StringToType(.Form.Item("cbeType_move"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valModulec"), eFunctions.Values.eTypeData.etdInteger), mobjValues.StringToType(.Form.Item("valCover"), eFunctions.Values.eTypeData.etdInteger), .Form.Item("tctExist_Modul"), mobjValues.StringToType(.Form.Item("tcnMonthi"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("tcnMonthe"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("cbeAply"), eFunctions.Values.eTypeData.etdLong, True), mobjValues.StringToType(.Form.Item("valOriAply"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("valFunds"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("tcnMinimumAmount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnMaximumAmount"), eFunctions.Values.eTypeData.etdDouble))
                        lclsLife_load = Nothing
                    End If
                End With

                '+ DP770: Productos que suman para capital
            Case "DP770"
                With Request
                    mobjProductSeq = New eProduct.Prod_addcap
                    If Request.QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.InsValDP770(.QueryString("Action"), "DP770", Session("nBranch"), Session("nProduct"), mobjValues.StringToType(.Form.Item("cbeBranch"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("valProduct"), eFunctions.Values.eTypeData.etdDouble, True), Session("dEffecdate"), mobjValues.StringToType(.Form.Item("hddCovergen"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeCover"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valRole"), eFunctions.Values.eTypeData.etdDouble))
                    End If
                End With

                '+ DP828: Condiciones para el cálculo de comisión en endosos
            Case "DP828"
                With Request
                    mobjProductSeq = New eProduct.Comm_mod
                    If Request.QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.InsValDP828(.QueryString("Action"), "DP828", Session("nBranch"), Session("nProduct"), mobjValues.StringToType(.Form.Item("valModulec_exc"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("valCover_exc"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valRole_exc"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valModulec_inc"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("valCover_inc"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valRole_inc"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeType_Comm"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate))
                    End If
                End With
                '+ DP080 validacion de coberturas y tipo de prestaciones

            Case "DP080"
                mobjProductSeq = New eProduct.Lend_Agree_Prod
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.insValDP080("DP080", .QueryString("Action"), Session("nBranch"), Session("nProduct"), mobjValues.StringToType(.Form.Item("cbeAply"), eFunctions.Values.eTypeData.etdDouble), Session("dEffecdate"))
                    End If
                End With

                '+ DP066: Limites permitidos por productos            
            Case "DP066"
                mobjProductSeq = New eProduct.Product_limits
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.InsValDP066_K(mobjValues.StringToType(.Form.Item("tcnlimit_type"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnlimit_code"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnvalmax"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnvalmin"), eFunctions.Values.eTypeData.etdDouble, True), .QueryString.Item("Action"), Session("dEffecdate"), Session("nBranch"), Session("nProduct"))
                    End If
                End With
                '+ DP7002: Finiquitos del producto            
            Case "DP7002"
                mobjProductSeq = New eProduct.Prodsettlement

                With Request
                    insvalSequence = mobjProductSeq.InsValDP7002("DP7002", mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("tcnOrder"), eFunctions.Values.eTypeData.etdDouble), .QueryString.Item("WindowType"))
                End With

                '+ DP103: Asimilación de figuras           
            Case "DP103"

                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        insvalSequence = mobjProductSeq.insValDP103(mobjValues.StringToType(.Form.Item("cbeOriginRole"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbePersontype"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeDestRole"), eFunctions.Values.eTypeData.etdDouble))
                    End If
                End With

            Case Else
                insvalSequence = "insvalSequence: Código lógico no encontrado (" & Request.QueryString.Item("sCodispl") & ")"

        End Select
    End Function

    '% insPostSequence: Se realizan las actualizaciones de las ventanas
    '--------------------------------------------------------------------------------------------
    Function insPostSequence() As Boolean
        Dim lintExists As Byte
        Dim lintIndex4 As Integer
        Dim lintChecked As Byte
        Dim lstrCompon As String
        Dim sReactivation As String
        Dim lstrchangetyp As String
        Dim sRealind As Byte
        Dim lintAction As Short
        '--------------------------------------------------------------------------------------------
        Dim lblnPost As Boolean
        Dim lclsProductWin As Object
        Dim lclsErrors As eFunctions.Errors

        lblnPost = True

        Dim lclsProduct_Win As eProduct.Prod_win
        Dim lclsTab_Clause As eProduct.Tab_Clause
        Dim lclsProd_reserve As eProduct.Prod_reserve
        Dim mobjCur_allow As eProduct.Cur_Allow
        Dim lclsCliallocla As eProduct.Cliallocla
        Dim lclsTar_am_Basprod As eBranches.Tar_am_basprod
        Dim lclsTab_am_excprod As eBranches.Tab_am_excprod
        Dim lclsTab_am_cli As eBranches.Tab_am_cli
        Dim lclsLimits_age As eBranches.Limits_age
        Dim lclsPay_fracti As ePolicy.Pay_Fracti
        Dim lclsNull_condi As eProduct.Null_condi
        Dim lclsBas_sumins As eProduct.Bas_sumins
        Dim lclsLife_load As eProduct.Life_load
        Dim lobjPostDP064 As eProduct.Product
        Dim mobjProductSeqDP066 As eProduct.Product_limits
        Select Case Request.QueryString.Item("sCodispl")

            '+ DP003_K: Características de los productos
            Case "DP003_K"
                mobjProductSeq = New eProduct.Product
                With Request
                    mobjProductSeq.sDescript = Session("DP003_sDescript")
                    mobjProductSeq.sShort_des = Session("DP003_sShort_des")
                    lblnPost = mobjProductSeq.insPostDP003_K(mobjValues.StringToType(.QueryString.Item("nMainAction"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("cbeProdType"), mobjValues.StringToType(.Form.Item("cbeBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcdEffecdate"), eFunctions.Values.eTypeData.etdDate))
                    If lblnPost Then
                        Session("bQuery") = .QueryString.Item("nMainAction") = CStr(eFunctions.Menues.TypeActions.clngActionQuery)
                        Session("dEffecdate") = mobjValues.TypeToString(mobjProductSeq.dEffecdate, eFunctions.Values.eTypeData.etdDate)
                        Session("sBrancht") = .Form.Item("cbeProdType")
                        Session("nBranch") = .Form.Item("cbeBranch")
                        Session("nProduct") = .Form.Item("valProduct")
                    End If
                End With

                '+ DP003: Información general
            Case "DP003"
                mobjProductSeq = New eProduct.Product
                With Request
                    If mobjValues.StringToType(.Form.Item("chkSimulator"), eFunctions.Values.eTypeData.etdDouble) = "1" Then
                        sRealind = 1
                    Else
                        sRealind = 2
                    End If

                    lblnPost = mobjProductSeq.insPostDP003(mobjValues.StringToType(.QueryString.Item("nMainAction"), eFunctions.Values.eTypeData.etdDouble), .QueryString("sCodispl"), mobjValues.StringToType(.Form.Item("tcnReference"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), Session("sBrancht"), .Form.Item("tctDescript"), .Form.Item("tctShortDes"), .Form.Item("cbeStatus"), mobjValues.StringToType(CStr(sRealind), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("chkIndividual"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("chkGroups"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("chkMulti"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnVersion"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeTypeHeap"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeReinHeap"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("valDeclarative"), mobjValues.StringToType(.Form.Item("tcnCurrencyQ"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("chkNumprop"), .Form.Item("tctCondSVS"), .Form.Item("chkAuto_susc"), .Form.Item("chkMassive"), .Form.Item("chkRatingServiceUsing"), .Form.Item("tctPreffix"), .Form.Item("chkAssociated_Policy_Required"), mobjValues.StringToType(.Form.Item("cbeAssociatedBranch"), eFunctions.Values.eTypeData.etdInteger), mobjValues.StringToType(.Form.Item("nTypeAccount"), eFunctions.Values.eTypeData.etdInteger), mobjValues.StringToType(.Form.Item("tcnModuleMin"), eFunctions.Values.eTypeData.etdInteger) ,  .Form.Item("chkAutomaticBill"), .Form.Item("tctResolutionSBS"))
                    If lblnPost Then
                        Response.Write("<SCRIPT>")
                        If Request.Form.Item("sCodisplReload") = vbNullString Then
                            Response.Write("top.frames[""fraHeader""].UpdateDiv(""valProductDesc"",'" & Request.Form.Item("tctDescript") & "','Normal');")
                        Else
                            Response.Write("opener.top.frames[""fraHeader""].UpdateDiv(""valProductDesc"",'" & Request.Form.Item("tctDescript") & "','Normal');")
                        End If
                        Response.Write("</" & "Script>")
                    End If
                End With

                '+ DP004: Campos requeridos en la emisión
            Case "DP004"
                mobjClient_req = New eProduct.Client_req
                With Request

                    If not .Form.GetValues("hddRequiered") is nothing then
                        For mintCount = 0 To .Form.GetValues("hddRequiered").Count - 1
                            lblnPost = mobjClient_req.insPostDP004(mobjValues.StringToType(.QueryString.Item("nMainAction"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valRole"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valTratypeP"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.GetValues("hddField").GetValue(mintCount), eFunctions.Values.eTypeData.etdDouble), .Form.GetValues("hddRequiered").GetValue(mintCount), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate))
                        Next
                        If lblnPost Then
                            lclsProduct_Win = New eProduct.Prod_win
                            Call lclsProduct_Win.Add_Prod_win(Session("nBranch"), Session("nProduct"), Session("dEffecdate"), "DP004", "2", Session("nUsercode"))
                            lclsProduct_Win = Nothing
                        End If
                    Else
                        lblnPost = True
                    end if
                End With

                '+ DP005: Respuestas Automáticas en la Emisión 
            Case "DP005"

                If Request.Form.Item("chkReactivation") = vbNullString Then
                    sReactivation = "2"
                Else
                    sReactivation = "1"
                End If

                mobjProductSeq = New eProduct.Product
                With Request
                    lblnPost = mobjProductSeq.insPostDP005(mobjValues.StringToType(.Form.Item("tcnAction"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToDate(Session("dEffecdate")), mobjValues.StringToType(.Form.Item("tcnCopy"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnTime"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnCancelnotice"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("cbeTypepolicy"), mobjValues.StringToType(.Form.Item("cbePayfrequen"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("cbeReinsuran"), .Form.Item("chkDeclapolicy"), .Form.Item("cbeRevalform"), .Form.Item("cbeRevalType"), mobjValues.StringToType(.Form.Item("tcnrevalfactor"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("chkAutoreneaw"), .Form.Item("cbeGrouprenew"), .Form.Item("cbePremium"), .Form.Item("cbeTaxes"), .Form.Item("cbeCommission"), .Form.Item("cbeInvocehold"), mobjValues.StringToType(.Form.Item("tcnQuotas"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeway_pay"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnbill_day"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("optTyp_dom"), .Form.Item("chksLeg"), mobjValues.StringToType(.Form.Item("tcnRehabperiod"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("chksReinst"), .Form.Item("chksDatecoll"), .Form.Item("chksFirst_pay"), mobjValues.StringToType(.Form.Item("tcnQdays_quo"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnQdays_pro"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnMonth_surr"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnNotCancelDay"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctRehaut_r"), .Form.Item("chkFracReceip"), mobjValues.StringToType(.Form.Item("tcnQdays_difquo"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("chkSetprem"), mobjValues.StringToType(.Form.Item("tcnMonth_Setpr"), eFunctions.Values.eTypeData.etdLong), .Form.Item("chkRetarif"), .Form.Item("chkRecSec"), mobjValues.StringToType(.Form.Item("tcnRehabperiod_aut"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("chksTarQuo_Ind"), mobjValues.StringToType(.Form.Item("tcnPayable"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("tcnAdvance"), eFunctions.Values.eTypeData.etdLong), sReactivation, mobjValues.StringToType(.Form.Item("tcnReactPeriod"), eFunctions.Values.eTypeData.etdInteger), mobjValues.StringToType(.Form.Item("tcnReactPeriod_Aut"), eFunctions.Values.eTypeData.etdInteger), .Form.Item("tctRoutReact"), mobjValues.StringToType(.Form.Item("tcnChUserLev"), eFunctions.Values.eTypeData.etdInteger), .Form.Item("tctRou_warning_charg"), .Form.Item("tctRou_cover"), mobjValues.StringToType(.Form.Item("cbeCurr_receipt"), eFunctions.Values.eTypeData.etdInteger))
                End With

                '+ DP008: Recargos y descuentos
            Case "DP008"
                mobjProductSeq = New eProduct.Disco_expr
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        mstrString = vbNullString
                        lblnPost = mobjProductSeq.insPostDP008("Upd", mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnExist"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnCode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), .Form.Item("tctDescript"), .Form.Item("tctShort_des"), mobjValues.StringToType(.Form.Item("tcnOrder_apl"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("cbeType"), .Form.Item("cbeStatregt"))
                    End If
                    Session("nDisexprc") = .Form.Item("tcnCode")
                End With

                '+ DP578: Vías de pago permitidas
            Case "DP578"

                Dim scollection As String
                mobjProductSeq = New eProduct.Way_pay_prod
                With Request

                    If .Form.Item("chkCollection") = "1" Then
                        scollection = "1"
                    Else
                        scollection = "2"
                    End If

                    If .QueryString.Item("WindowType") = "PopUp" Then
                        mstrString = vbNullString
                        lblnPost = mobjProductSeq.insPostDP578Upd(.QueryString("Action"),
                                                                  mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble),
                                                                  mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble),
                                                                  mobjValues.StringToType(.Form.Item("cbeWay_pay"), eFunctions.Values.eTypeData.etdDouble),
                                                                  mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate),
                                                                  mobjValues.StringToType(.Form.Item("tcnRate_ex"), eFunctions.Values.eTypeData.etdDouble),
                                                                  mobjValues.StringToType(.Form.Item("tcnRate_disc"), eFunctions.Values.eTypeData.etdDouble),
                                                                  .Form.Item("chkPrem_first"),
                                                                  mobjValues.StringToType(.Form.Item("tcnNull_day"), eFunctions.Values.eTypeData.etdDouble),
                                                                  mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble),
                                                                  .Form.Item("chkLastReceipt"),
                                                                  .Form.Item("chkOneReceipt"),
                                                                  scollection)
                    End If
                    Session("nWay_pay") = .Form.Item("cbeWay_pay")
                End With


                '+ DP578A: Frecuencias de pago permitidas
            Case "DP578A"
                mobjProductSeq = New eProduct.Freq_way_prod
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        mstrString = vbNullString

                        If .Form.Item("tcnExist") = "0" Then
                            lblnPost = mobjProductSeq.insPostDP578Upd("Add", mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnWay_pay"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbePayFreq"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("cbeCurrency"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPre_issue"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPre_amend"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnQprem"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("sIva"), mobjValues.StringToType(Request.Form.Item("tcLimit_ExcTax"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("sNo_sell"))
                        Else
                            lblnPost = mobjProductSeq.insPostDP578Upd("Update", mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnWay_pay"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbePayFreq"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("cbeCurrency"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPre_issue"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPre_amend"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnQprem"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("sIva"), mobjValues.StringToType(Request.Form.Item("tcLimit_ExcTax"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("sNo_sell"))

                        End If
                    End If
                    lblnPost = True
                    Session("nPayFreq") = .Form.Item("cbePayFreq")
                End With

                '+ DP010: Frecuencias de Pago Permitidas
            Case "DP010"

                '+ Se coloca el TRUE el valor de lblnPost para que la secuencia permita pasar a la 
                '+ siguiente transacción 
                If Request.QueryString.Item("WindowType") = "PopUp" Then
                    mobjProductSeq = New ePolicy.Pay_Fracti
                    If Request.QueryString.Item("Action") = "Add" Or Request.QueryString.Item("Action") = "Update" Then
                        lintAction = 1
                    Else
                        lintAction = 2
                    End If

                    lblnPost = mobjProductSeq.insPostDP010(lintAction, mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("cboPay_fracti"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Request.Form.Item("tcnRatepayf"), eFunctions.Values.eTypeData.etdDouble), Request.Form.Item("cboStatregt"), mobjValues.StringToType(Request.Form.Item("tcnQuota"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))
                End If

                '+ DP027: Criterios técnicos - Selección de riesgo.
            Case "DP027"
                If Request.QueryString.Item("WindowType") = "PopUp" Then
                    mobjProductSeq = New eProduct.Life_speci

                    lblnPost = mobjProductSeq.insPostDP027(Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Request.Form.Item("nConsec"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("nAgeend"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("nAgestart"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("nCapend"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("nCapstart"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("nCurrencyAux"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("nCrthecni"), eFunctions.Values.eTypeData.etdDouble), Request.Form.Item("sSexinsur"), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("cbenModule"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("cbenCover"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("cbeRole"), eFunctions.Values.eTypeData.etdLong))
                    If lblnPost Then
                        lclsProduct_Win = New eProduct.Prod_win

                        Call lclsProduct_Win.Add_Prod_win(Session("nBranch"), Session("nProduct"), Session("dEffecdate"), "DP027", "2", Session("nUsercode"))
                        lclsProduct_Win = Nothing
                    End If
                End If

                '+ DP101: Conceptos de pago por producto
            Case "DP101"
                If Request.QueryString.Item("WindowType") = "PopUp" Then
                    mobjProductSeq = New eProduct.Prod_Am_Bil

                    lblnPost = mobjProductSeq.insPostDP101(Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(Request.Form.Item("cbenModulec"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(Request.Form.Item("cbenCover"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(Request.Form.Item("cbenRole"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(Request.Form.Item("tcnGroup_Pres"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(Request.Form.Item("tcnPay_Concep"), eFunctions.Values.eTypeData.etdLong), Request.Form.Item("valIllness"), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Request.Form.Item("cbenCurrency"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(Request.Form.Item("tcnDed_Type"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(Request.Form.Item("tcnDed_Amount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnDed_Percen"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnDed_Quanti"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnIndem_rate"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnLimit"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnTypLim"), eFunctions.Values.eTypeData.etdLong, True), mobjValues.StringToType(Request.Form.Item("tcnCount"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(Request.Form.Item("tcnLimit_exe"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnPunish"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(Request.Form.Item("tcnDed_Quanti_2"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnIndem_Rate_2"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnLimit_2"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnTypLim_2"), eFunctions.Values.eTypeData.etdLong, True), mobjValues.StringToType(Request.Form.Item("tcnCount_2"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(Request.Form.Item("tcnLimit_exe_2"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnPunish_2"), eFunctions.Values.eTypeData.etdLong), Session("nUsercode"))

                    If lblnPost Then
                        lclsProduct_Win = New eProduct.Prod_win

                        Call lclsProduct_Win.Add_Prod_win(Session("nBranch"), Session("nProduct"), Session("dEffecdate"), "DP101", "2", Session("nUsercode"))
                        lclsProduct_Win = Nothing
                    End If
                End If


                '+ DP809: Reportes automaticos para el producto.
            Case "DP809"
                If Request.QueryString.Item("WindowType") = "PopUp" Then
                    mobjProductSeq = New eProduct.report_prod
                    lblnPost = mobjProductSeq.insPostDP809(Request.QueryString("Action"), _
                                                                       mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), _
                                                                       mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), _
                                                                       mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), _
                                                                       "DP809", _
                                                                       Request.Form("valCodispl"), _
                                                                       mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), _
                                                                       mobjValues.StringToType(Request.Form("cbeReptype"), eFunctions.Values.eTypeData.etdLong, True), _
                                                                       mobjValues.StringToType(Request.Form("cbeTransaction"), eFunctions.Values.eTypeData.etdLong, True), _
                                                                       Request.Form("tctReport"))
                End If

                '+ DP031: Características Particulares de Ramos Generales
            Case "DP031"
                mobjProductSeq = New eProduct.Product_ge
                With Request
                    lblnPost = mobjProductSeq.insPostDP031(mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), CStr(.Form.Item("chkResmaypa")), mobjValues.StringToType(.Form.Item("tcnLevelpay"), eFunctions.Values.eTypeData.etdDouble), CStr(.Form.Item("optDamage")), CStr(.Form.Item("cboPayconre")), mobjValues.StringToType(.Form.Item("tcnClaimpres"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cboCurrency"), eFunctions.Values.eTypeData.etdDouble), CStr(.Form.Item("optNoAplied")), mobjValues.StringToType(.Form.Item("tcnPreissue"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnFrancRat"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPre_amend"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnFix"), eFunctions.Values.eTypeData.etdDouble), CStr(.Form.Item("optCapApl")), mobjValues.StringToType(.Form.Item("tcnFrancMin"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnFrancmax"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("chkSuspendi"), mobjValues.StringToType(.Form.Item("cbeLineSuscrip"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnClaimNotice"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnClaimPay"), eFunctions.Values.eTypeData.etdDouble) ,  mobjValues.StringToType(.Form.Item("cbeDuplicatedType"), eFunctions.Values.eTypeData.etdInteger))
                End With

                '+ DP036: Elementos de Protección 
            Case "DP036"
                mobjProductSeq = New eProduct.Product

                Select Case Request.QueryString.Item("Action")
                    Case "Add"
                        lintAction = 0
                    Case "Update"
                        lintAction = 1
                    Case "Delete"
                        lintAction = 2
                End Select
                If Request.QueryString.Item("WindowType") = "PopUp" Then
                    lblnPost = mobjProductSeq.insPostDP036(mobjValues.StringToType(CStr(lintAction), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnElement"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType("", eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Request.Form.Item("cbeCurrency"), eFunctions.Values.eTypeData.etdDouble), Request.Form.Item("tctElementDescription"), mobjValues.StringToType(Request.Form.Item("tcnFixAmount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnMaxAmount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnMinAmount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnDisrate"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType("", eFunctions.Values.eTypeData.etdDate), Request.Form.Item("tctShortDescription"), Request.Form.Item("cbeState"), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), Request.Form.Item("tctRoutine"), mobjValues.StringToType(Request.Form.Item("tcnInitialSelection"), eFunctions.Values.eTypeData.etdDouble))
                End If

                '+ DP037: Tabla de Corto Plazo
            Case "DP037"
                mobjProductSeq = New eProduct.Tab_short
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lblnPost = mobjProductSeq.insPostDP037(.QueryString("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnMonthMax"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnDaysMax"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Request.Form.Item("tcnRateDevolution"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnRatePremium"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))
                    End If
                End With

                '+ DP038: Requisitos y exclusiones
            Case "DP038"
                mobjProductSeq = New eProduct.Tab_reqexc
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lblnPost = mobjProductSeq.insPostDP038(Request.QueryString.Item("sCodispl"), mobjValues.StringToType(Request.QueryString.Item("nMainAction"), eFunctions.Values.eTypeData.etdDouble), Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("tctRelation"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tctType1"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tctElement1"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valRole1"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tctType2"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tctElement2"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valRole2"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("hddDefReq"), eFunctions.Values.eTypeData.etdLong))
                    End If
                End With

                '+ DP042: Clientes Permitidos
            Case "DP042"

                mobjProductSeq = New eProduct.Product

                If Request.QueryString.Item("WindowType") = "PopUp" Then
                    If Request.Form.Item("tctComponent") <> vbNullString Then
                        lstrCompon = Request.Form.Item("tctComponent")
                    Else
                        lstrCompon = "1"
                    End If

                    '+ Se evalúa el valor del campo tcnMaxValue. Si es cero (0) o Nulo, se inserta el registro en
                    '+ la base de datos, de lo contrario se hace una actualización 
                    If CDbl(Request.Form.Item("tcnMaxValue2")) <= 0 Then
                        lintExists = 2
                        lintAction = 301
                    Else
                        lintExists = 1
                        lintAction = 302
                    End If

                    lintChecked = 1

                    With Request

                        'Response.Write "mobjProductSeq.insPostDP042(" & mobjValues.StringToType(lintAction,eFunctions.Values.eTypeData.etdDouble) & "," &                 '                                           mobjValues.StringToType(Session("nBranch"),eFunctions.Values.eTypeData.etdDouble) & "," &                 '                                           mobjValues.StringToType(Session("nProduct"),eFunctions.Values.eTypeData.etdDouble) & "," &                 '                                           mobjValues.StringToType(Session("dEffecdate"),eFunctions.Values.eTypeData.etdDate) & "," &                 '                                           .Form("tctPoliType") & "," &                 '                                           lstrCompon & "," &                 '                                           mobjValues.StringToType(.Form("cboClientRol"),eFunctions.Values.eTypeData.etdDouble) & "," &                 '                                           .Form("sDefault") & "," &  _
                        ''                                           .Form("sRequired") & "," &                 '                                           mobjValues.StringToType(.Form("tcnMaxValue"),eFunctions.Values.eTypeData.etdDouble) & "," &                 '                                           mobjValues.StringToType(Session("nUsercode"),eFunctions.Values.eTypeData.etdDouble) & "," &                 '                                           CStr(lintChecked) & "," &                 '                                           .Form("tctInitialSelection") & "," &                 '                                           mobjValues.StringToType(lintExists,eFunctions.Values.eTypeData.etdDouble) & ")"

                        lblnPost = mobjProductSeq.insPostDP042(mobjValues.StringToType(CStr(lintAction), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), .Form.Item("tctPoliType"), lstrCompon, mobjValues.StringToType(.Form.Item("cboClientRol"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("sDefault"), .Form.Item("sRequired"), mobjValues.StringToType(.Form.Item("tcnMaxValue"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), CStr(lintChecked), .Form.Item("tctInitialSelection"), mobjValues.StringToType(CStr(lintExists), eFunctions.Values.eTypeData.etdDouble), .Form.Item("sOptionalQuo"))
                    End With
                Else
                    lblnPost = True
                End If

                '+ DP011: Conceptos de facturación
            Case "DP011"
                mobjProductSeq = New eProduct.Tab_bill_i
                With Request
                    lblnPost = True
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lblnPost = mobjProductSeq.insPostDP011(.QueryString("sCodispl"), .QueryString("Action"), Session("nBranch"), Session("nProduct"), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("tcnBill_item"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctDescript"), .Form.Item("tctShort_des"), Session("nUsercode"))
                    End If
                End With

                '+ DP032: Módulos de un producto
            Case "DP032"
                lblnPost = True

                mobjProductSeq = New eProduct.Tab_modul
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        If .Form.Item("chknRateadd") = "1" And .Form.Item("chknRatesub") = "1" Then
                            lstrchangetyp = "4"
                        Else
                            If .Form.Item("chknRateadd") = "1" Then
                                lstrchangetyp = "2"
                            Else
                                If .Form.Item("chknRatesub") = "1" Then
                                    lstrchangetyp = "3"
                                Else
                                    lstrchangetyp = "1"
                                End If
                            End If
                        End If
                        lblnPost = mobjProductSeq.insPostDP032(.QueryString("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnModulec"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), .Form.Item("chkChanallo"), .Form.Item("chkDefaulti"), .Form.Item("chkRequire"), .Form.Item("tctDescript"), .Form.Item("tctShort_des"), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctCondSVS"), mobjValues.StringToType(.Form.Item("tcnPremirat"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnchprelev"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnRatepreadd"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnRatepresub"), eFunctions.Values.eTypeData.etdDouble, True), lstrchangetyp, .Form.Item("chkStyp_rat"), .Form.Item("chksVigen"))
                    End If
                End With

                '+ DP009: Cláusula/Descriptivo/Condición Especial
            Case "DP009"
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lclsTab_Clause = New eProduct.Tab_Clause
                        lblnPost = lclsTab_Clause.insPostDP009(mobjValues.StringToType(.QueryString.Item("nAction"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnClause"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToDate(Session("dEffecdate")), .Form.Item("chkDefaulti"), .Form.Item("tctDescript"), .Form.Item("tctShort_des"), mobjValues.StringToType(.Form.Item("tcnNotenum"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valModulec"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valCover"), eFunctions.Values.eTypeData.etdDouble), "", mobjValues.StringToType(.Form.Item("cbeType"), eFunctions.Values.eTypeData.etdLong, True))
                        lclsTab_Clause = Nothing
                    End If
                End With

                '+ DP201: Reserva por producto
            Case "DP201"
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lclsProd_reserve = New eProduct.Prod_reserve
                        lblnPost = lclsProd_reserve.insPostDP210(.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeType_reserve"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valModulec"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valCover"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToDate(Session("dEffecdate")), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctRoureser"))
                        lclsProd_reserve = Nothing
                    End If
                End With

                '+ DP033: Coberturas de un módulo o producto 
            Case "DP033"
                With Request

                    mobjProductSeq = New eProduct.Gen_cover

                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lblnPost = mobjProductSeq.insPostDP033Upd(.QueryString("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnModulec"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("nCover"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("nCovergen"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("sStatregt"), Session("sBrancht"))

                    Else
                        lblnPost = mobjProductSeq.InsPostDP033(mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), Session("sBrancht"))
                    End If
                End With

                '+ DP055: Monedas            
            Case "DP055"
                mobjCur_allow = New eProduct.Cur_Allow
                With Request
                    lblnPost = mobjCur_allow.insPostDP055(.QueryString.Item("sCodispl"), mobjValues.StringToType(Request.QueryString.Item("nMainAction"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("hSel"), .Form.Item("hCurrency"), .Form.Item("htctPreSelection"), .Form.Item("hCodigint"))
                End With
                mobjCur_allow = Nothing

                '+ DP056: Clientes Permitidos en un Siniestro
            Case "DP056"
                lclsCliallocla = New eProduct.Cliallocla
                With Request
                    If .Form.GetValues("tcnAuxRole").Count > 1 Then
                        For lintIndex4 = 0 To .Form.GetValues("tcnAuxRole").Count - 1
                            If CDbl(.Form.GetValues("sAuxSel").GetValue(lintIndex4)) = 1 Or CDbl(.Form.GetValues("chkAuxExist").GetValue(lintIndex4)) = 1 Then
                                lblnPost = lclsCliallocla.insPostDP056(mobjValues.StringToType(.QueryString.Item("Action"), eFunctions.Values.eTypeData.etdDouble), "DP056", .Form.GetValues("sAuxSel").GetValue(lintIndex4), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.GetValues("tcnAuxRole").GetValue(lintIndex4), eFunctions.Values.eTypeData.etdDouble), .Form.GetValues("chkAuxRequire").GetValue(lintIndex4), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), .Form.GetValues("chkAuxExist").GetValue(lintIndex4), mobjValues.StringToDate(Session("dEffecdate")), .Form.GetValues("tctAuxDefaultClaInd").GetValue(lintIndex4))
                            End If
                        Next
                    End If
                    lclsCliallocla = Nothing
                End With

                '+ DP057: Tarifas de atención médica
            Case "DP057"
                lclsTar_am_Basprod = New eBranches.Tar_am_basprod
                With Request
                    If Request.QueryString.Item("WindowType") = "PopUp" Then
                        mstrString = "&nTariff=" & Request.Form.Item("hddTariff") & "&sChanges=" & Request.Form.Item("hddChanges") & "&sDefaulti=" & Request.Form.Item("hddDefaulti") & "&nBenefType=" & Request.Form.Item("hddBenef_Type") & "&nLimit=" & Request.Form.Item("hddLimit") & "&nDed_amount=" & Request.Form.Item("hddDeduc_amount") & "&nModulec=" & Request.Form.Item("hddModulec") & "&nCover=" & Request.Form.Item("hddCover") & "&sDescript=" & Request.Form.Item("hddDescript")

                        lblnPost = lclsTar_am_Basprod.insPostDP057("DP057", Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("hddTariff"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("hddChanges"), .Form.Item("hddDefaulti"), mobjValues.StringToType(.Form.Item("hddBenef_Type"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("hddLimit"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("hddDeduc_amount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnAgeInit"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnAgeEnd"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnComp_group"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("tcnPremium"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), .QueryString.Item("WindowType"), mobjValues.StringToType(.Form.Item("hddModulec"), eFunctions.Values.eTypeData.etdInteger), mobjValues.StringToType(.Form.Item("hddCover"), eFunctions.Values.eTypeData.etdInteger), Request.Form.Item("hddDescript"))
                    Else
                        mstrString = "&nTariff=" & Request.Form.Item("tcnTariff") & "&sChanges=" & Request.Form.Item("chkChanges") & "&sDefaulti=" & Request.Form.Item("chkDefaulti") & "&nBenefType=" & Request.Form.Item("cbeBenefType") & "&nLimit=" & Request.Form.Item("tcnLimit") & "&nDed_amount=" & Request.Form.Item("tcnDed_amount") & "&nModulec=" & Request.Form.Item("tcnModulec") & "&nCover=" & Request.Form.Item("tcnCover") & "&sDescript=" & Request.Form.Item("tctDescript")

                        lblnPost = lclsTar_am_Basprod.insPostDP057("DP057", Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnTariff"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("chkChanges"), .Form.Item("chkDefaulti"), mobjValues.StringToType(.Form.Item("cbeBenefType"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnLimit"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnDed_amount"), eFunctions.Values.eTypeData.etdDouble), 0, 0, 0, mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), 0, mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), .QueryString.Item("WindowType"), mobjValues.StringToType(.Form.Item("cbeModulec"), eFunctions.Values.eTypeData.etdInteger), mobjValues.StringToType(.Form.Item("valCover"), eFunctions.Values.eTypeData.etdInteger), Request.Form.Item("tctDescript"))
                        If lblnPost Then
                            lclsProduct_Win = New eProduct.Prod_win
                            Call lclsProduct_Win.Add_Prod_win(Session("nBranch"), Session("nProduct"), Session("dEffecdate"), "DP057", "2", Session("nUsercode"))
                            lclsProduct_Win = Nothing
                        End If
                    End If
                    lclsTar_am_Basprod = Nothing
                End With

                '+ DP058: Exclusión de enfermedades
            Case "DP058"
                lclsTab_am_excprod = New eBranches.Tab_am_excprod

                If Request.QueryString.Item("WindowType") = "PopUp" Then

                    lblnPost = lclsTab_am_excprod.insPostDP058("DP058", Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("nTariff"), eFunctions.Values.eTypeData.etdDouble), CStr(Request.Form.Item("cbeDescript")), mobjValues.StringToType(Request.Form.Item("tcdInit_date"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Request.Form.Item("tcdEnd_date"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Request.Form.Item("cbeExc_code"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Request.Form.Item("dEffecdate_reg"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))



                Else
                    lblnPost = True

                End If

                lclsTab_am_excprod = Nothing

                '+ DP059: Clínicas
            Case "DP059"
                lclsTab_am_cli = New eBranches.Tab_am_cli
                If Request.QueryString.Item("WindowType") = "PopUp" Then
                    lblnPost = lclsTab_am_cli.insPostDP059("DP059", Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("cbeHospital"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Request.Form.Item("tcdEffecdate_reg"), eFunctions.Values.eTypeData.etdDate, True), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))



                End If
                lclsTab_am_cli = Nothing

                '+ Edades Limites de asegurados
            Case "DP060"
                lclsLimits_age = New eBranches.Limits_age

                If Request.QueryString.Item("WindowType") = "PopUp" Then

                    lblnPost = lclsLimits_age.insPostDP060("DP060", Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("cbeRelation"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnAge"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToDate(Session("dEffecdate")), mobjValues.StringToType(Request.Form.Item("tcdEffecdate_reg"), eFunctions.Values.eTypeData.etdDate, True), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))

                End If

                lclsLimits_age = Nothing

                '+ DP010: Frecuencia de Pagos permitidos        
            Case "DP010"
                lclsPay_fracti = New ePolicy.Pay_Fracti
                lblnPost = lclsPay_fracti.insPostDP010(1, mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("cboPay_fracti"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToDate(Session("dEffecdate")), mobjValues.StringToType(Request.Form.Item("tcnRatepayf"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("cboStatregt"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnQuota"), eFunctions.Values.eTypeData.etdDouble, 0), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))
                lclsPay_fracti = Nothing

                '+ DP061: Condiciones de Anulación
            Case "DP061"
                lclsNull_condi = New eProduct.Null_condi
                lblnPost = lclsNull_condi.insPostDP061(Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToDate(Session("dEffecdate")), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("cboNullcode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Request.Form.Item("tcnAmelevel"), eFunctions.Values.eTypeData.etdDouble), "1", CStr(Request.Form.Item("cboReturn_ind")), mobjValues.StringToType(Request.Form.Item("tcnReturn_rat"), eFunctions.Values.eTypeData.etdDouble), "1", Request.Form.Item("chkNotRehab"), Request.Form.Item("chkReaAut"), Request.Form.Item("tctRoutine_Pay"), mobjValues.StringToType(Request.Form.Item("tcnRetraction"), eFunctions.Values.eTypeData.etdDouble))
                lclsNull_condi = Nothing

                '+ DP062: Capitales basicos
            Case "DP062"
                lclsBas_sumins = New eProduct.Bas_sumins
                If Request.QueryString.Item("WindowType") = "PopUp" Then
                    lblnPost = lclsBas_sumins.insPostDP062(Request.QueryString.Item("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToDate(Session("dEffecdate")), Request.Form.Item("tctDescript"), Request.Form.Item("tctShort_des"), mobjValues.StringToType(Request.Form.Item("tcnAuxSumins_co"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))
                End If
                lclsBas_sumins = Nothing

                '+ DP023: Datos del Colectivo
            Case "DP023"
                mobjProductSeq = New eProduct.Product
                With Request
                    lblnPost = mobjProductSeq.insPostDP023(Session("nBranch"), Session("nProduct"), Session("dEffecdate"), .Form.Item("cbeReceiptType"), .Form.Item("cbeClauseType"), .Form.Item("cbeXpremType"), .Form.Item("cbeCoverType"), mobjValues.StringToType(.Form.Item("tcnMaxInsured"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnMinInsured"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("chkUseGroups"), Session("nUsercode"), .Form.Item("optPremCalc"), Session("sBrancht"), mobjValues.StringToType(.Form.Item("cbeRepInsured"), eFunctions.Values.eTypeData.etdDouble))
                End With

                '+ DP012: Secuencia para el tratamiento de pólizas
            Case "DP012"
                With Request
                    mobjProductSeq = New eProduct.Sequen_pol
                    lblnPost = mobjProductSeq.insPostDP012(.QueryString("nMainAction"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), .Form.Item("optBussityp"), .Form.Item("optPolitype"), .Form.Item("optCompon"), .Form.Item("cbeTransaction"), .Form.Item("hddCodispl").Replace(",", ", "), .Form.Item("hddSequence").Replace(",", ", "), .Form.Item("hddAuxRequire").Replace(",", ", "), .Form.Item("hddSel").Replace(",", ", "), .Form.Item("hddAutomatic").Replace(",", ", "), Session("nUsercode"), .Form.Item("cbeType_Amend"))
                    If lblnPost Then
                        If .Form.Item("hddMassive") = "2" Then
                            lclsErrors = New eFunctions.Errors

                            '+ Se manda un mensaje indicando que ya se actualizaron los datos en la tabla
                            Response.Write(lclsErrors.ErrorMessage("DP012", 55867, , , , True))
                            lclsErrors = Nothing
                        End If
                    End If
                End With

                '+ DP048: Secciones a incluir en el cuadro de pólizas
            Case "DP048"
                With Request
                    mobjProductSeq = New eProduct.Section_po
                    If .QueryString("WindowType") <> "PopUp" Then


                        lblnPost = mobjProductSeq.insPostDP048(mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble),
                                                               mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble),
                                                               mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate),
                                                               .Form.Item("hddPolitype"),
                                                               .Form.Item("hddCompon"),
                                                               .Form.Item("hddCodispl"),
                                                               .Form.Item("hddSel"),
                                                               mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble),
                                                               mobjValues.StringToType(.Form.Item("cbeTratypep"), eFunctions.Values.eTypeData.etdDouble),
                                                               mobjValues.StringToType(.Form.Item("valType_amend"), eFunctions.Values.eTypeData.etdDouble),
                                                               mobjValues.StringToType(.Form.Item("valOrigin"), eFunctions.Values.eTypeData.etdDouble))

                        If lblnPost Then
                            If .Form.Item("hddMassive") = "2" Then
                                lclsErrors = New eFunctions.Errors

                                '+ Se manda un mensaje indicando que ya se actualizaron los datos en la tabla
                                Response.Write(lclsErrors.ErrorMessage("DP012", 55867, , , , True))
                                lclsErrors = Nothing
                            End If
                        End If
                    Else
                        lblnPost = mobjProductSeq.InsPostDP048UPD(Request.QueryString("sAction"),
                                                                  mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble),
                                                                  mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble),
                                                                .Form("hddsPolitype"),
                                                                .Form("hddsCompon"),
                                                                .Form("hddnTratypep"),
                                                                .Form("hddCodispl"),
                                                                mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate),
                                                                .Form("hddnId"),
                                                                .Form("tctsReport"),
                                                                .Form("tctnOrder"),
                                                                .Form("tctsRoutine"),
                                                                mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))
                    End If
                End With

                '+ DP041: Descuentos por Siniestralidad
            Case "DP041"
                With Request
                    mobjProductSeq = New eProduct.Tar_au_bon
                    lblnPost = True
                    If Request.QueryString.Item("WindowType") = "PopUp" Then
                        lblnPost = mobjProductSeq.insPostDP041(.QueryString("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(.Form.Item("tcnYear"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnClaimrat"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnDiscount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))
                    End If
                End With



                '+ DP100: Bienes asegurados permitidos
            Case "DP100"
                mobjProductSeq = New ePolicy.Tab_goods
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lblnPost = mobjProductSeq.insPostDP100(.QueryString("Action"), mobjValues.StringToType(.QueryString.Item("nMainAction"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnCode_good"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctDescript"), .Form.Item("tctShort_des"), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnRate"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctRoutine"), mobjValues.StringToType(.Form.Item("tcnRatChaAdd"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnRatChaSub"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnLevelCha"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), .Form.Item("chkIncrease"), .Form.Item("chkDecrease"))
                    End If
                End With

                '+ DP102: Tipos de desglose
            Case "DP102"
                mobjProductSeq = New ePolicy.Detailsallowed
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lblnPost = mobjProductSeq.insPostDP102(.QueryString("Action"), mobjValues.StringToType(.QueryString.Item("nMainAction"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeType"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnCode_good"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctDescript_Good"), mobjValues.StringToType(.Form.Item("cbeAddCapital"), eFunctions.Values.eTypeData.etdDouble), Session("nUsercode"), Session("dEffecdate"))
                    End If
                End With



                '+ DP043: Carasterísticas de vida I
            Case "DP043"
                mobjProductSeq = New eProduct.ProdLifeSeq
                With Request
                    If .QueryString.Item("WindowType") <> "PopUp" Then
                        lblnPost = mobjProductSeq.insPostDP043("DP043", mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeProdclas"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeCurrency"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("chkMorCapii"), .Form.Item("chkAssociai"), .Form.Item("optAssoTotal"), .Form.Item("optPremiumtype"), mobjValues.StringToType(.Form.Item("cbeTypdurins"), eFunctions.Values.eTypeData.etdDouble, True), .Form.Item("optIdurvari"), mobjValues.StringToType(.Form.Item("tcnIduraFix"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnMinRent"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnMaxRent"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeTypdurpay"), eFunctions.Values.eTypeData.etdDouble, True), .Form.Item("optIpayvari"), .Form.Item("sRoutine"), .Form.Item("tctRoutinsu"), .Form.Item("tctRoutpay"), mobjValues.StringToType(.Form.Item("nQMonVPN"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("chkAPV"), mobjValues.StringToType(.Form.Item("tcnBmg"), eFunctions.Values.eTypeData.etdLong), .Form.Item("tctRoutinevpn"), .Form.Item("chkNo_Holidays"))
                    Else
                        If Request.QueryString.Item("sArrayName") = "Durinsu" Then
                            '+ Se realizan las actualizaciones de la grilla de duraciones del seguro
                            mobjProductSeq = New eProduct.Durinsu_prod
                            lblnPost = mobjProductSeq.insPostDP043Upd(.QueryString("Action"), Session("nBranch"), Session("nProduct"), mobjValues.StringToType(.Form.Item("tcnIduraFix"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeTypeInsur1"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnMinDurIns"), eFunctions.Values.eTypeData.etdDouble), Session("dEffecdate"), Session("nUsercode"))
                        Else
                            '+ Se realizan las actualizaciones de la grilla de duraciones de los pagos
                            mobjProductSeq = New eProduct.Durpay_prod
                            lblnPost = mobjProductSeq.insPostDP043Upd(.QueryString("Action"), mobjValues.StringToType(.Form.Item("hddID"), eFunctions.Values.eTypeData.etdDouble), Session("nBranch"), Session("nProduct"), Session("dEffecdate"), mobjValues.StringToType(.Form.Item("cbeIdurafix"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnPdurafix"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeTypeInsur"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("cbeTypePay"), eFunctions.Values.eTypeData.etdDouble), Session("nUsercode"))
                        End If
                    End If
                    mstrQueryString = "&nProdclas=" & .Form.Item("cbeProdclas") & "&nCurrency=" & .Form.Item("cbeCurrency") & "&sMorcapii=" & .Form.Item("chkMorcapii") & "&nMinrent=" & .Form.Item("tcnMinrent") & "&sRoutine=" & .Form.Item("sRoutine") & "&nMaxrent=" & .Form.Item("tcnMaxrent") & "&sAssociai=" & .Form.Item("chkAssociai") & "&sPremiumtype=" & .Form.Item("optPremiumtype") & "&sAssoTotal=" & .Form.Item("optAssoTotal") & "&nTypdurins=" & .Form.Item("cbeTypdurins") & "&sIdurvari=" & .Form.Item("optIdurvari") & "&nTypdurpay=" & .Form.Item("cbeTypDurPay") & "&sPdurvari=" & .Form.Item("optIpayvari") & "&sRoutinsu=" & .Form.Item("tctRoutinsu") & "&sRoutpay=" & .Form.Item("tctRoutpay") & "&bWithInformation=" & .Form.Item("hddbWithInformation") & "&sArrayName=" & Request.QueryString.Item("sArrayName") & "&sApv=" & .Form.Item("chkApv") & "&sNo_Holidays=" & .Form.Item("chkNo_Holidays")
                End With

                '**+ DP064: Charges over deposits and current accounts
                '+ DP064: Cargos sobre aportes y cuentas corrientes
                '+ [APV2] HAD 1021 – Cambios en la lógica de descuento de los costos coberturas. DBLANCO 03-09-2003

            Case "DP064"

                lclsLife_load = New eProduct.Life_load

                With Request
                    If .QueryString.Item("WindowType") <> "PopUp" Then
                        lobjPostDP064 = New eProduct.Product

                        If lobjPostDP064.insPostDP064(Session("nBranch"), Session("nProduct"), Session("dEffecdate"), CInt(.Form.Item("tcnDayBuyUnit"))) Then

                            lclsProduct_Win = New eProduct.Prod_win
                            lblnPost = lclsProduct_Win.Add_Prod_win(Session("nBranch"), Session("nProduct"), Session("dEffecdate"), "DP064", "2", Session("nUsercode"))
                            lclsProduct_Win = Nothing
                        End If
                        lobjPostDP064 = Nothing
                    Else
                        lblnPost = lclsLife_load.insPostDP064(.QueryString.Item("Action"), 1, mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnLoad_cod"), eFunctions.Values.eTypeData.etdDouble), Session("dEffecdate"), .Form.Item("tctDescript"), mobjValues.StringToType(.Form.Item("cbeLoad_type"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnLoadAmo"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnLoadRate"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("cbeStatregt"), .Form.Item("tctShort_des"), mobjValues.StringToType(.Form.Item("cbePayFreq"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("tctRoutine"), .Form.Item("chkPreInv"), mobjValues.StringToType(.Form.Item("cbeType_move"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), .Form.Item("chkFirst_cost_pro"), mobjValues.StringToType(.Form.Item("valModulec"), eFunctions.Values.eTypeData.etdInteger), mobjValues.StringToType(.Form.Item("valCover"), eFunctions.Values.eTypeData.etdInteger), .Form.Item("chkTaxin"), mobjValues.StringToType(.Form.Item("tcnMonthi"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("tcnMonthe"), eFunctions.Values.eTypeData.etdLong), mobjValues.StringToType(.Form.Item("cbeAply"), eFunctions.Values.eTypeData.etdLong, True), mobjValues.StringToType(.Form.Item("valOriAply"), eFunctions.Values.eTypeData.etdLong), .Form.Item("chkRetro"), .Form.Item("chkPremBas"), mobjValues.StringToType(.Form.Item("valFunds"), eFunctions.Values.eTypeData.etdLong), .Form.Item("chkInstallind"), .Form.Item("chkFirst_apply"), mobjValues.StringToType(.Form.Item("cbeIndex_table"), eFunctions.Values.eTypeData.etdLong, True), mobjValues.StringToType(.Form.Item("tcnMinimumAmount"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnMaximumAmount"), eFunctions.Values.eTypeData.etdDouble))
                    End If
                End With
                lclsLife_load = Nothing

                '+ DP705: Tipos de asegurados por cobertura
            Case "DP705"
                mobjProductSeq = New eProduct.Tab_covrol
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lblnPost = mobjProductSeq.insPostDP705(.QueryString("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("hddnModulec"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("hddnCover"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("hddnRole"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), .Form.Item("cbeStatregt"), Session("sBrancht"), .Form.Item("chkRequired"), .Form.Item("chkDefaulti"), mobjValues.StringToType(.Form.Item("hddnExist"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnMax_role"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("valCovActiv_rel_nRole"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("valCovActiv_rel"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))
                    End If

                    lblnPost = mobjProductSeq.InsPostDP705_K(mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))
                End With

                '+ DP607: Condiciones generales de productos de VidActiva
            Case "DP607"
                With Request
                    lblnPost = mobjProductSeq.insPostDP607("DP607", mobjValues.StringToType(.QueryString.Item("nMainAction"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnPremMin"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnQMonVPN"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnQMonToVPN"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnRateReh"), eFunctions.Values.eTypeData.etdDouble, True))
                End With

                '+ DP770: Productos que suman para capital
            Case "DP770"
                mobjProductSeq = New eProduct.Prod_addcap
                With Request
                    lblnPost = mobjProductSeq.InsPostDP770(Session("nBranch"), Session("nProduct"), mobjValues.StringToType(.Form("cbeCover"), eFunctions.Values.eTypeData.etdLong, True), mobjValues.StringToType(.Form("valRoleM"), eFunctions.Values.eTypeData.etdLong, True), Session("dEffecdate"), .Form("hddnBranchadd"), .Form("hddnProductadd"), .Form("hddnCoveradd"), .Form("hddnRoleadd"), .Form("hddnClusteradd"), .Form("hddnCapitaladd"), .Form("hddnId"), .Form("hddnInverse"), mobjValues.StringToType(.Form("tcnCapital"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(CStr(Session("nUsercode")), eFunctions.Values.eTypeData.etdLong))
                End With
                '+ DP080: Prestadores en convenios
            Case "DP080"
                mobjProductSeq = New eProduct.Lend_Agree_Prod
                With Request
                    With Request
                        insPostSequence = mobjProductSeq.InsPostDP080(.QueryString("Action"), Session("nBranch"), Session("nProduct"), mobjValues.StringToType(.Form.Item("cbeAply"), eFunctions.Values.eTypeData.etdDouble), Session("dEffecdate"), Session("nUsercode"))

                    End With
                End With
                '+ DP828: Condiciones para el cálculo de comisión en endosos
            Case "DP828"
                mobjProductSeq = New eProduct.Comm_mod
                With Request
                    If Request.QueryString.Item("WindowType") = "PopUp" Then
                        lblnPost = mobjProductSeq.InsPostDP828(.QueryString("Action"), mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valModulec_exc"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("valCover_exc"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valRole_exc"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valModulec_inc"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("valCover_inc"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("valRole_inc"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeType_Comm"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))

                    Else
                        lblnPost = mobjProductSeq.InsPostDP828_Win(Session("nBranch"), Session("nProduct"), Session("dEffecdate"), Session("nUsercode"))
                    End If
                End With

                '+ DP066: Limites por productos
            Case "DP066"
                mobjProductSeqDP066 = New eProduct.Product_limits
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lblnPost = mobjProductSeqDP066.InsPostDP066("Add", mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnlimit_type"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnlimit_code"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnvalmax"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(.Form.Item("tcnvalmin"), eFunctions.Values.eTypeData.etdDouble, True), mobjValues.StringToType(Session("dEffecdate"), eFunctions.Values.eTypeData.etdDate), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))
                    End If
                End With

                '+ DP7002: Finiquitos de un producto
            Case "DP7002"
                mobjProductSeq = New eProduct.Prodsettlement
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lblnPost = mobjProductSeq.insPostDP7002("Add", "DP7002", mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnSettlecode"), eFunctions.Values.eTypeData.etdDouble), Session("dEffecdate"), mobjValues.StringToType(.Form.Item("hddnCovergen"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("hddnCover"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("hddnPay_concep"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("tcnOrder"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))
                    End If
                End With

                '+ DP103: Asimilación de figuras
            Case "DP103"
                With Request
                    If .QueryString.Item("WindowType") = "PopUp" Then
                        lblnPost = mobjProductSeq.insPostDP103("Add", mobjValues.StringToType(Session("nBranch"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nProduct"), eFunctions.Values.eTypeData.etdDouble), Session("dEffecdate"), mobjValues.StringToType(.Form.Item("cbeOriginRole"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbePersontype"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(.Form.Item("cbeDestRole"), eFunctions.Values.eTypeData.etdDouble), mobjValues.StringToType(Session("nUsercode"), eFunctions.Values.eTypeData.etdDouble))
                    End If
                End With

        End Select
        insPostSequence = lblnPost
    End Function

    '% insFinish: se activa al finalizar el proceso
    '--------------------------------------------------------------------------------------------
    Function insFinish() As Boolean
        '--------------------------------------------------------------------------------------------
        insFinish = True

        mstrLocationBC003 = "'/VTimeNet/Common/secWHeader.aspx?sCodispl=DP003_K&sModule=Product&sProject=ProductSeq&sProduct=ProductSeq'"
    End Function

</script>
<%Response.Expires = -1

    mobjValues = New eFunctions.Values
    mstrCommand = "sModule=Product&sProject=ProductSeq&sCodisplReload=" & Request.QueryString.Item("sCodispl")
%>
<HTML>
<HEAD>
     <META NAME="GENERATOR" CONTENT="Microsoft Visual Studio 6.0"/>
<SCRIPT LANGUAGE="JavaScript" SRC="/VTimeNet/Scripts/GenFunctions.js"></SCRIPT>
    <%=mobjValues.StyleSheet()%>



    
<SCRIPT>
    //- Variable para el control de versiones
    document.VssVersion = "$$Revision: 2 $|$$Date: 26-09-09 0:01 $|$$Author: Ljimenez $"
</SCRIPT>
</HEAD>
<BODY>
<FORM ID=FORM1 NAME=FORM1>
    <%
        mstrLocationBC003 = "'/VTimeNet/Common/GoTo.aspx?sCodispl=DP003_K'"

        '+ Si no se han validado los campos de la página
        If Request.Form.Item("sCodisplReload") = vbNullString Then
	mstrErrors = insvalSequence
            Session("sErrorTable") = mstrErrors
            Session("sForm") = Request.Form.ToString
        Else
            Session("sErrorTable") = vbNullString
            Session("sForm") = vbNullString
        End If

If Request.QueryString.Item("nAction") <> CStr(eFunctions.Menues.TypeActions.clngAcceptdataFinish) Then
            If mstrErrors > vbNullString Then
                With Response
			.Write("<SCRIPT LANGUAGE=JAVASCRIPT>")
			.Write("ShowPopUp(""/VTimeNet/Common/Errors.aspx?sSource=" & Server.URLEncode(mstrCommand) & "&sQueryString=" & Server.URLEncode(Request.Params.Get("Query_String")) & """, ""ProductSeqErrors"",660,330);self.document.location.href='/VTimeNet/common/blank.htm';")
                    .Write(mobjValues.StatusControl(False, CShort(Request.QueryString.Item("nZone")), Request.QueryString.Item("WindowType")))
			.Write("</SCRIPT>")
                End With
            Else
		If insPostSequence Then
                    If Request.QueryString.Item("WindowType") <> "PopUp" Then
                        '+ Si se está tratando con un frame y no con la ventana principal de la secuencia, 
                        '+ se mueve automaticamente a la siguiente página. Sólo en caso que sea la ventana DP043
                        '+ se mantiene en la página por si se quiere ir a la secuencia de Carac. de vida.
                        '+ Se da el mismo tratamiento a DP607
                        lstrGoToNext = "Yes"
                        If Request.QueryString.Item("sCodispl") = "DP043" Or Request.QueryString.Item("sCodispl") = "DP607" Or (Request.QueryString.Item("sCodispl") = "DP004" And Request.Form.Item("hddMassive") = "2") Or (Request.QueryString.Item("sCodispl") = "DP012" And Request.Form.Item("hddMassive") = "2") Or (Request.QueryString.Item("sCodispl") = "DP048" And Request.Form.Item("hddMassive") = "2") Then
                            If Request.QueryString.Item("sCodispl") = "DP043" Then
						Response.Write("<SCRIPT>top.frames['fraFolder'].document.location.href='" & Request.QueryString.Item("sCodispl") & ".aspx?sCodispl=" & Request.QueryString.Item("sCodispl") & "&ReloadAction=Update&nMainAction=" & Request.QueryString.Item("nMainAction") & mstrQueryString & "'</SCRIPT>")
                            Else
						Response.Write("<SCRIPT>top.frames['fraFolder'].document.location=top.frames['fraFolder'].document.location</SCRIPT>")
                            End If
                            If Request.Form.Item("hddbWithInformation") <> "True" Then
                                lstrGoToNext = "No"
                            End If
                        End If
                        If Request.Form.Item("sCodisplReload") = vbNullString Then
					Response.Write("<SCRIPT>top.frames['fraSequence'].document.location=""/VTimeNet/Product/ProductSeq/Sequence.aspx?nAction=" & Request.QueryString.Item("nMainAction") & "&sGoToNext=" & lstrGoToNext & "&nOpener=" & Request.QueryString.Item("sCodispl") & """;</SCRIPT>")
                        Else
					Response.Write("<SCRIPT>window.close();opener.top.frames['fraSequence'].document.location=""/VTimeNet/Product/ProductSeq/Sequence.aspx?nAction=" & Request.QueryString.Item("nMainAction") & "&sGoToNext=" & lstrGoToNext & "&nOpener=" & Request.QueryString.Item("sCodispl") & """;</SCRIPT>")
                        End If
                    Else
                        If Request.QueryString.Item("sCodispl") <> "DP578A" Then
                            Response.Write("<script>top.opener.top.frames['fraSequence'].document.location='/VTimeNet/Product/ProductSeq/Sequence.aspx?nAction=" & Request.QueryString.Item("nMainAction") & "&nOpener=" & Request.QueryString.Item("sCodispl") & "&sGoToNext=NO" & "';</script>")
                        End If
                        '+ Se recarga la página que invocó la PopUp
                        Select Case Request.QueryString.Item("sCodispl")
                            Case "DP009", "DP037", "DP010", "DP061", "DP062", "DP036", "DP809", "DP059", "DP032", "DP041", "DP100", "DP060", "DP828", "DP201"
                                If Request.Form.Item("sCodisplReload") = vbNullString Then
                                    Response.Write("<script>top.opener.document.location.href='" & Request.QueryString.Item("sCodispl") & ".aspx?sCodispl=" & Request.QueryString.Item("sCodispl") & "&Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & "&nMainAction=" & Request.QueryString.Item("nMainAction") & "'</script>")
                                Else
                                    Response.Write("<script>top.opener.top.opener.document.location.href='" & Request.QueryString.Item("sCodispl") & ".aspx?sCodispl=" & Request.QueryString.Item("sCodispl") & "&Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & "&nMainAction=" & Request.QueryString.Item("nMainAction") & "';window.close();</script>")
                                End If
                            Case "DP008"
                                If Request.QueryString.Item("Action") = "Add" Then
                                    mstrString = "&nDisexprc=" & Request.Form.Item("tcnCode") & "&nOrderApl=" & Request.Form.Item("tcnOrder_apl") & "&sDescript=" & Request.Form.Item("tctDescript") & "&nType=" & Request.Form.Item("cbeType")
                                End If
                                Response.Write("<script>top.opener.document.location.href='" & Request.QueryString.Item("sCodispl") & ".aspx?Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & mstrString & "&sCodispl=" & Request.QueryString.Item("sCodispl") & "'</script>")
						
                            Case "DP578"
                                If Request.QueryString.Item("Action") = "Add" Then
                                    mstrString = "&nWay_pay=" & Request.Form.Item("cbeWay_pay") & "&nRate_ex=" & Request.Form.Item("tcnRate_ex") & "&nRate_disc=" & Request.Form.Item("tcnRate_disc") & "&sPrem_first=" & Request.Form.Item("sPrem_first") & "&nNull_day=" & Request.Form.Item("tcnNull_day")
                                End If
                                Response.Write("<script>top.opener.document.location.href='" & Request.QueryString.Item("sCodispl") & ".aspx?Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & mstrString & "&sCodispl=" & Request.QueryString.Item("sCodispl") & "'</script>")
						
                            Case "DP578A"
                                Response.Write("<script>top.opener.top.document.location.reload()</script>")
						
                            Case "DP027"
                                Response.Write("<script>top.opener.document.location.href='" & Request.QueryString.Item("sCodispl") & ".aspx?Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & "&cbenModule=" & Request.Form.Item("cbenModule") & "&cbenCover=" & Request.Form.Item("cbenCover") & "'</script>")
						
                            Case "DP101"
                                Response.Write("<script>top.opener.document.location.href='" & Request.QueryString.Item("sCodispl") & ".aspx?Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & "&nCover=" & Request.Form.Item("cbenCover") & "&nRole=" & Request.Form.Item("cbenRole") & "&sIllness=" & Request.Form.Item("valIllness") & "&nModulec=" & Request.Form.Item("cbenModulec") & "&nCurrency=" & Request.Form.Item("nCurrency") & "'</script>")
						
                            Case "DP033"
                                Response.Write("<script>top.opener.document.location.href='" & Request.QueryString.Item("sCodispl") & ".aspx?sCodispl=" & Request.QueryString.Item("sCodispl") & "&Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & "&nCover=" & Request.Form.Item("nCover") & "&nCovergen=" & Request.Form.Item("nCovergen") & "&nModulec=0" & Request.Form.Item("tcnModulec") & "'</script>")
						
                            Case "DP048"
                                Response.Write("<script>top.opener.document.location.href='DP048.aspx?sCodispl=" & Request.QueryString.Item("sCodispl") & "&Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & "&sPolitype=" & Request.Form.Item("hddPolitype") & "&sCompon=" & Request.Form.Item("hddCompon") & "'</script>")
						
                            Case "DP011"
                                Response.Write("<script>top.opener.document.location.href='" & Request.QueryString.Item("sCodispl") & ".aspx?Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & "&sCodispl=" & Request.QueryString.Item("sCodispl") & "'</script>")
						
                            Case "DP042"
                                Response.Write("<script>top.opener.document.location.href='" & Request.QueryString.Item("sCodispl") & ".aspx?Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & "&sPoliType=" & Request.Form.Item("tctPoliType") & "&sComponent=" & Request.Form.Item("tctComponent") & "'</script>")
						
                            Case "DP057"
                                Response.Write("<script>top.opener.document.location.href='DP057.aspx?Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & mstrString & "'</script>")
						
                            Case "DP058"
                                Response.Write("<script>top.opener.document.location.href='DP058.aspx?Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & "&mintTariff=" & Request.Form.Item("nTariff") & "&mstrTypeExcl=" & Request.Form.Item("sType_Excl") & "'</script>")
						
                            Case "DP064"
                                Response.Write("<script>top.opener.document.location.href='DP064.aspx?Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & "'</script>")
						
                            Case "DP705"
                                Response.Write("<script>top.opener.document.location.href='" & Request.QueryString.Item("sCodispl") & ".aspx?Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & "&nModulec=" & Request.Form.Item("hddnModulec") & "&nCover=" & Request.Form.Item("hddnCover") & "&nRole=" & Request.Form.Item("hddnRoleSel") & "&nExist=" & Request.Form.Item("hddnExist") & "'</script>")
                            Case "DP080"
                                Response.Write("<script>top.opener.document.location.href='DP080.aspx?Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & "&nModulec=" & Request.QueryString.Item("nModulec") & "&nCover=" & Request.QueryString.Item("nCover") & "'</script>")
                            Case "DP038"
                                Response.Write("<script>top.opener.document.location.href='" & Request.QueryString.Item("sCodispl") & ".aspx?sCodispl=" & Request.QueryString.Item("sCodispl") & "&Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("Index") & "&nMainAction=" & Request.QueryString.Item("nMainAction") & "&nDefReq=" & Request.Form.Item("hddDefReq") & "'</script>")
						
                            Case Else
                                Response.Write("<script>top.opener.document.location.href='" & Request.QueryString.Item("sCodispl") & ".aspx?sCodispl=" & Request.QueryString.Item("sCodispl") & "&Reload=" & Request.Form.Item("chkContinue") & "&ReloadAction=" & Request.QueryString.Item("Action") & "&ReloadIndex=" & Request.QueryString.Item("ReloadIndex") & "&nMainAction=" & Request.QueryString.Item("nMainAction") & mstrQueryString & "'</script>")
                        End Select
                    End If
                End If
            End If
        Else
            If Request.QueryString.Item("nMainAction") = CStr(eFunctions.Menues.TypeActions.clngActionQuery) Or Session("bQuery") Then
                Response.Write("<script>top.location.reload();</script>")
            Else
		
                '+ Se recarga la página principal de la secuencia            
                If insFinish() Then
                    Response.Write("<script>top.opener.top.document.location=" & mstrLocationBC003 & ";</script>")
                End If
            End If
        End If
        mobjProductSeq = Nothing
        mobjValues = Nothing
    %>
    </form>
</body>
</html>
