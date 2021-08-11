Option Strict Off
Option Explicit On
Imports System.Text.RegularExpressions
Public Class ClientSeq
	'%-------------------------------------------------------%'
	'% $Workfile:: ClientSeq.cls                            $%'
	'% $Author:: Ljimenez                                   $%'
	'% $Date:: 6-10-09 14:35                                $%'
	'% $Revision:: 5                                        $%'
	'%-------------------------------------------------------%'
	
	'- Se define la variable mstrError, para contener el mensaje de error resultante de la ejecuci�n de un
	'- Acceso a la BD.
	
	Private mstrError As String
	
	'% insvalBC003_K: validaciones de la transaccion BC003_K
	Public Function insvalBC003_K(ByVal sCodispl As String, ByVal sClient As String, ByVal nAction As Integer, ByVal nUsercode As String, ByVal nPerson_typ As Integer, ByVal sDigit As String) As String
        'Dim lstrErrors As String
		Dim lobjErrors As Object
        Dim lobjClient As Client
        Dim sMessajeRet As String
        
		lobjErrors = eRemoteDB.NetHelper.CreateClassInstance("eFunctions.Errors")
		lobjClient = New Client
		
		'+ Validaciones del campo cliente
		'+ Debe estar lleno
		If Trim(sClient) = String.Empty Then
			lobjErrors.ErrorMessage(sCodispl, 2001)
			'+ El primer carcter del c�digo debe corresponder con uno v�lido
		Else
			If Not lobjClient.ValidateClientStruc(sClient) Then
				lobjErrors.ErrorMessage(sCodispl, 2012)
				'+Si la acci�n no es "registrar", debe existir en el archivo de clientes
			ElseIf lobjClient.Find(lobjClient.sClient, True) Then 
				If nAction = 301 Then
					lobjErrors.ErrorMessage(sCodispl, 2065)
				End If
			Else
				If nAction <> 301 Then
					lobjErrors.ErrorMessage(sCodispl, 1007)
				End If
			End If
		End If
		
		'+ Validaciones del d�gito verificador
		'+ Debe estar lleno
		If nAction = 301 Or nAction = 302 Then
			If sDigit = String.Empty And Trim(sClient) <> String.Empty Then
				lobjErrors.ErrorMessage(sCodispl, 2090)
			Else
				If sDigit <> String.Empty Then
                    If UCase(sDigit) <> "E" Then
                        'INICIO DMendoza 11/08/2021
                        ' Se comenta validaci�n del digito verificador para que consulte en la BD
                        'If lobjClient.GetRUT(sClient) <> UCase(sDigit) Then
                        '    lobjErrors.ErrorMessage(sCodispl, 55032)
                        'End If
                        If UCase(lobjClient.sDigit) <> UCase(sDigit) Then
                            lobjErrors.ErrorMessage(sCodispl, 55032)
                        End If
                        'FIN DMendoza 11/08/2021
                    End If
                End If
			End If
		End If
		
		'+ Validaciones del campo tipo de persona
		'+ Debe estar lleno
		If nPerson_typ = eRemoteDB.Constants.intNull Then
			lobjErrors.ErrorMessage(sCodispl, 11334)
		Else
            If nAction = 301 Then
                If nPerson_typ = 1 AndAlso IsNumeric(sClient) AndAlso CLng(sClient) >= 50000000 Then
                    lobjErrors.ErrorMessage(sCodispl, 2150, , eFunctions.Errors.TextAlign.RigthAling, "natural no debe ser mayor o igual a 50.000.000")
                End If
                If nPerson_typ = 2 AndAlso IsNumeric(sClient) AndAlso CLng(sClient) < 50000000 AndAlso CLng(sClient) > 0 Then
                    lobjErrors.ErrorMessage(sCodispl, 2150, , eFunctions.Errors.TextAlign.RigthAling, "juridica no debe ser menor a 50.000.000")
                End If
            End If
		End If

        '+ Validaciones 
        '+ El usuario puede modificar o consultar este cliente 
        If nAction <> 301 Then
            sMessajeRet = ""
            If lobjClient.Validate_Client(sClient, nAction, nUsercode, eRemoteDB.Constants.dtmNull, sMessajeRet) Then
                If sMessajeRet <> "OK" Then
                    lobjErrors.ErrorMessage(sCodispl, 1102, , eFunctions.Errors.TextAlign.LeftAling, sMessajeRet)
                End If
            End If
        End If

        insvalBC003_K = lobjErrors.Confirm
        'UPGRADE_NOTE: Object lobjClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        lobjClient = Nothing
    End Function
	
	
	'% insPostBC003_k: Realiza el post de la transaccion
	Public Function insPostBC003_k(ByVal sClient As String, ByVal nAction As Integer, ByVal nUsercode As String, ByVal nPersonType As Integer, ByVal sDigit As String) As Boolean
		Dim lobjClient As Client
		Dim lclsClientWin As ClientWin
		
		lobjClient = New Client
		lclsClientWin = New ClientWin
		If nAction = 301 Then 'Registrar
			With lobjClient
				.nUsercode = CInt(nUsercode)
				.nPerson_typ = nPersonType
				.sDigit = sDigit
				insPostBC003_k = .Add(sClient)
			End With
		ElseIf nAction = 303 Then  'Eliminar
			With lobjClient
				If .Find(sClient) Then
					insPostBC003_k = .Delete
				End If
			End With
		ElseIf nAction = 302 Then  'Modificar
			insPostBC003_k = lobjClient.UpdateBC003_k(sClient, nPersonType, CInt(nUsercode))
			
		End If
		
		'UPGRADE_NOTE: Object lobjClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lobjClient = Nothing
		'UPGRADE_NOTE: Object lclsClientWin may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClientWin = Nothing
	End Function
	
	'% insPostBC002: Se realiza la actualizaci�n de los datos
	Public Function insPostBC002(ByVal Action As String, ByVal sClient As String, ByVal sClientr As String, ByVal sCliename As String, ByVal nRelaship As String, ByVal nUsercode As String, Optional ByVal nOriginalRelaship As String = "") As Boolean
		Dim lclsRelation As Relation
		Dim lclsClientWin As ClientWin
		Dim lcolRelation As Relations
		Dim lclsClient As Client
		Dim lstrContent As String
		
		On Error GoTo insValBC002_Err
		lclsClient = New Client
		sClient = lclsClient.ExpandCode(UCase(sClient))
		sClientr = lclsClient.ExpandCode(UCase(sClientr))
		'UPGRADE_NOTE: Object lclsClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClient = Nothing
		
		lclsRelation = New Relation
		With lclsRelation
			.sClient = sClient
			.sClientr = sClientr
			.nRelaship = CInt(nRelaship)
			Select Case Action
				Case "Add"
					'+ Se crea la relaci�n directa y la inversa (si aplica).
					.sCliename = sCliename
					.nUsercode = CShort(nUsercode)
					insPostBC002 = .Add
				Case "Delete"
					'+ Se elimina la relaci�n directa y la inversa (si aplica).
					insPostBC002 = .Delete
				Case "Update"
					'+ Se elimina la relaci�n original
					.nRelaship = CInt(nOriginalRelaship)
					insPostBC002 = .Delete
					
					'+ Se crea la nueva relaci�n
					.nRelaship = CInt(nRelaship)
					.sCliename = sCliename
					.nUsercode = CShort(nUsercode)
					insPostBC002 = .Add
					
			End Select
			If insPostBC002 Then
				lcolRelation = New Relations
				lstrContent = IIf(lcolRelation.Find(sClient), "2", "1")
				lclsClientWin = New ClientWin
				lclsClientWin.insUpdClient_win(sClient, "BC002", lstrContent)
				'UPGRADE_NOTE: Object lcolRelation may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
				lcolRelation = Nothing
			End If
		End With
		
insValBC002_Err: 
		If Err.Number Then
			insPostBC002 = False
		End If
		'UPGRADE_NOTE: Object lclsRelation may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsRelation = Nothing
		'UPGRADE_NOTE: Object lclsClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClient = Nothing
		'UPGRADE_NOTE: Object lclsClientWin may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClientWin = Nothing
		On Error GoTo 0
	End Function
	
	'% insValBC014: se realizan las validaciones -puntuales y/o masivas- que se realizan a los
	'%              campos del frame.
	Public Function insValBC014(ByVal sCodispl As String, ByVal sClient As String, ByVal dFinanDate As Date, ByVal nConcept As Integer, ByVal nUnits As Integer, ByVal nCurrency As Integer, ByVal nAmount As Double, ByVal nFinanStat As Integer, Optional ByVal sAction As String = "") As String
		Dim lclsClient As eClient.Client
		Dim lobjErrors As eFunctions.Errors
		Dim lclsFinancCli As eClient.Financ_Cli
		Dim lvalField As eFunctions.valField
		Dim lclsQuery As eRemoteDB.Query
		Dim lblnDateValid As Boolean
		
		lblnDateValid = False
		lclsFinancCli = New eClient.Financ_Cli
		lclsClient = New eClient.Client
		lobjErrors = New eFunctions.Errors
		lvalField = New eFunctions.valField
		lclsQuery = New eRemoteDB.Query
		
		On Error GoTo insValBC014_Err
		
		lvalField.objErr = lobjErrors
		'+ Validaci�n del campo FECHA
		
		'+ Debe estar lleno
		If dFinanDate = eRemoteDB.Constants.dtmNull Then
			Call lobjErrors.ErrorMessage(sCodispl, 2808)
		Else
			If lvalField.ValDate(dFinanDate,  , eFunctions.valField.eTypeValField.onlyvalid) Then
				lblnDateValid = True
				If lclsClient.Find(sClient) Then
					'+ La fecha debe ser mayor o igual a la fecha de creaci�n del cliente
					If dFinanDate < lclsClient.dInpdate Then
						Call lobjErrors.ErrorMessage(sCodispl, 9052)
					End If
				End If
				If dFinanDate > Today Then
					Call lobjErrors.ErrorMessage(sCodispl, 55852)
				End If
			End If
		End If
		
		'+ Validaci�n del campo CONCEPTO
		
		'+ Si el campo FECHA tiene informaci�n, debe estar lleno
		If lblnDateValid Then
			If nConcept = eRemoteDB.Constants.intNull Or nConcept = 0 Then
				Call lobjErrors.ErrorMessage(sCodispl, 2809)
			Else
				Select Case nConcept
					
					Case 1 '+ L�mite de cr�dito
						
						'+ Validaci�n del campo MONEDA
						If dFinanDate <> eRemoteDB.Constants.dtmNull And (nCurrency = eRemoteDB.Constants.intNull Or nCurrency = 0) And lblnDateValid Then
							Call lobjErrors.ErrorMessage(sCodispl, 10827)
						End If
						
						'+ Validaci�n del campo MONTO
						If dFinanDate <> eRemoteDB.Constants.dtmNull And (nAmount = eRemoteDB.Constants.intNull Or nAmount = 0) And lblnDateValid Then
							Call lobjErrors.ErrorMessage(sCodispl, 2812)
						End If
						
					Case 2 '+ Volumen de p�lizas anuales
						
						'+ Validaci�n del campo CANTIDAD
						If dFinanDate <> eRemoteDB.Constants.dtmNull And (nUnits = eRemoteDB.Constants.intNull Or nUnits = 0) And lblnDateValid Then
							Call lobjErrors.ErrorMessage(sCodispl, 2810)
						End If
						
					Case 3 '+ Total de prima anual (local)
						
						'+ Validaci�n del campo MONEDA
						If dFinanDate <> eRemoteDB.Constants.dtmNull And (nCurrency = eRemoteDB.Constants.intNull Or nCurrency = 0) And lblnDateValid Then
							Call lobjErrors.ErrorMessage(sCodispl, 10827)
						End If
						
						'+ Validaci�n del campo MONTO
						If dFinanDate <> eRemoteDB.Constants.dtmNull And (nAmount = eRemoteDB.Constants.intNull Or nAmount = 0) And lblnDateValid Then
							Call lobjErrors.ErrorMessage(sCodispl, 2812)
						End If
						
					Case 4 ' Capital (moneda local)
						
						'+ Validaci�n del campo MONEDA
						If dFinanDate <> eRemoteDB.Constants.dtmNull And (nCurrency = eRemoteDB.Constants.intNull Or nCurrency = 0) And lblnDateValid Then
							Call lobjErrors.ErrorMessage(sCodispl, 10827)
						End If
						
						
						'+ Validaci�n del campo MONTO
						If dFinanDate <> eRemoteDB.Constants.dtmNull And (nAmount = eRemoteDB.Constants.intNull Or nAmount = 0) And lblnDateValid Then
							Call lobjErrors.ErrorMessage(sCodispl, 2812)
						End If
						
					Case 5 '+ Cantidad de empleados
						
						'+ Validaci�n del campo CANTIDAD
						If dFinanDate <> eRemoteDB.Constants.dtmNull And (nUnits = eRemoteDB.Constants.intNull Or nUnits = 0) And lblnDateValid Then
							Call lobjErrors.ErrorMessage(sCodispl, 2810)
						End If
				End Select
			End If
		End If
		
		'+ Validaci�n del campo CANTIDAD
		
		'+ Si es un valor num�rico
		If nUnits <> eRemoteDB.Constants.intNull Then
			With lclsQuery
				If .OpenQuery("Table563", "sDescript", "nCodigint=108") Then
					lvalField.Descript = .FieldToClass("sDescript") & " :"
					.CloseQuery()
				End If
			End With
			If Not lvalField.ValNumber(nUnits,  , eFunctions.valField.eTypeValField.onlyvalid) Then
				insValBC014 = CStr(False)
			End If
		End If
		
		
		'+ Validaci�n del campo MONTO
		If nAmount <> eRemoteDB.Constants.intNull Then
			With lvalField
				.Min = 0
				.Max = 999999999999.99
				.ErrRange = 1935
				With lclsQuery
					If .OpenQuery("Table563", "sDescript", "nCodigint=109") Then
						lvalField.Descript = .FieldToClass("sDescript")
						.CloseQuery()
					End If
				End With
				If Not .ValNumber(nAmount,  , eFunctions.valField.eTypeValField.onlyvalid) Then
					insValBC014 = CStr(False)
				End If
			End With
		End If
		
		
		'+ Validaci�n del campo ESTADO
		
		'+ Si el campo FECHA tiene informaci�n, debe estar lleno
		If dFinanDate <> eRemoteDB.Constants.dtmNull And (nFinanStat = eRemoteDB.Constants.intNull Or nFinanStat = 0) And lblnDateValid Then
			Call lobjErrors.ErrorMessage(sCodispl, 1922)
		End If
		
		'+ La combinaci�n Fecha-Concepto no puede estar duplicada
		If dFinanDate <> eRemoteDB.Constants.dtmNull And (nConcept <> eRemoteDB.Constants.intNull And nConcept <> 0) And lblnDateValid And sAction = "Add" Then
			If lclsFinancCli.Find(sClient, dFinanDate, nConcept) Then
				Call lobjErrors.ErrorMessage(sCodispl, 2811)
			End If
		End If
		
		insValBC014 = lobjErrors.Confirm
		
		'UPGRADE_NOTE: Object lclsFinancCli may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsFinancCli = Nothing
		'UPGRADE_NOTE: Object lclsClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClient = Nothing
		'UPGRADE_NOTE: Object lobjErrors may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lobjErrors = Nothing
		'UPGRADE_NOTE: Object lvalField may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lvalField = Nothing
		'UPGRADE_NOTE: Object lclsQuery may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsQuery = Nothing
insValBC014_Err: 
		If Err.Number Then
			insValBC014 = "insValBC014: " & Err.Description
		End If
		
		On Error GoTo 0
	End Function
	
	'% insValBC002: se realizan las validaciones -puntuales y/o masivas- que se sobre los
	'%              campos del frame.
	Public Function insvalBC002(ByVal sCodispl As String, ByVal sClientr As String, ByVal nRelaship As String, ByVal sClientSession As String) As String
		Dim lclsClient As eClient.Client
		Dim lclsErrors As eFunctions.Errors
		Dim lclsRelation As eClient.Relation
		Dim lclstab_relat As eClient.Tab_relat
		
		Dim lblnDateValid As Boolean
		
		lblnDateValid = False
		
		lclsRelation = New eClient.Relation
		lclsClient = New eClient.Client
		lclsErrors = New eFunctions.Errors
		lclstab_relat = New eClient.Tab_relat
		
		On Error GoTo insValBC002_Err
		
		sClientr = lclsClient.ExpandCode(UCase(sClientr))
		sClientSession = lclsClient.ExpandCode(UCase(sClientSession))
		
		'+ Validaci�n del campo Cliente (sClientr)
		'+ Debe estar lleno
		If sClientr = String.Empty Then
			Call lclsErrors.ErrorMessage(sCodispl, 2792)
			
			'+ No debe existir relaci�n con el propio cliente
		ElseIf sClientr = sClientSession And CDbl(nRelaship) <> 19 Then 
			Call lclsErrors.ErrorMessage(sCodispl, 2053)
		Else
			'+ Validaci�n de existencia del cliente
			If Not lclsClient.Find(sClientr) Then
				Call lclsErrors.ErrorMessage(sCodispl, 1007)
			End If
			'+ No puede existir relacion duplicada
			If lclsRelation.Find(sClientSession, sClientr, CInt(nRelaship)) Then
				Call lclsErrors.ErrorMessage(sCodispl, 2019)
			End If
		End If
		
		'+ Validaci�n del campo Relaci�n (nRelaship)
		'+ Debe estar lleno
		If CShort(nRelaship) <= 0 Then
			Call lclsErrors.ErrorMessage(sCodispl, 2018)
		Else
			With lclstab_relat
				If .Find(CInt(nRelaship)) Then
					If .sStatregt <> "1" Then
                        Call lclsErrors.ErrorMessage(sCodispl, 2064)
                    ElseIf .sStatregt_target <> "1" Then 'En caso de que el nexo en de relacion inversa este inactivo en Table15
                        Call lclsErrors.ErrorMessage(sCodispl, 2064)
                    End If
				End If
			End With
			
			'+ No puede existir relacion duplicada para Grupo empresarial
			If CShort(nRelaship) = 19 Then
				If lclsRelation.Find(sClientSession, "", CInt(nRelaship)) Then
					Call lclsErrors.ErrorMessage(sCodispl, 55950)
				End If
			End If
		End If
		
		insvalBC002 = lclsErrors.Confirm
		
insValBC002_Err: 
		If Err.Number Then
			insvalBC002 = "insvalBC002: " & Err.Description
		End If
		On Error GoTo 0
		'UPGRADE_NOTE: Object lclsClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClient = Nothing
		'UPGRADE_NOTE: Object lclsRelation may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsRelation = Nothing
        'UPGRADE_NOTE: Object lclsErrors may not .be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsErrors = Nothing
		'UPGRADE_NOTE: Object lclstab_relat may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclstab_relat = Nothing
	End Function
	
	'% insValBC001N: realiza las validaciones de los campos de la forma
    Public Function insValBC001N(ByVal sCodispl As String, ByRef nValue As Integer, ByVal nAction As Integer, ByVal nPersonType As Integer, Optional ByVal dInpdate As Date = Nothing, Optional ByVal sLastName As String = "", Optional ByVal sFirstName As String = "", Optional ByVal nCivilsta As Integer = eRemoteDB.Constants.intNull, Optional ByVal sSexclien As String = "", Optional ByVal nNationality As Integer = eRemoteDB.Constants.intNull, Optional ByVal nSpecialit As Integer = eRemoteDB.Constants.intNull, Optional ByVal dBirthdat As Date = Nothing, Optional ByVal dDriverdat As Date = Nothing, Optional ByVal sLicence As String = "", Optional ByVal dDeathdat As Date = Nothing, Optional ByVal lblnPolicy As Boolean = False, Optional ByVal tctLastname2 As String = "", Optional ByVal dDrivexpdat As Date = Nothing, Optional ByVal dWedd As Date = Nothing) As String
        Dim lobjErrors As eFunctions.Errors
        Dim lclsValField As eFunctions.valField
        Dim sRx As String = "(^[a-zA-Z���-��-��-��-��-��-��-��-�\-\,\.\'\s" & ControlChars.Quote & "]*$)"


        On Error GoTo insValBC001N_Err
        lobjErrors = New eFunctions.Errors
        lclsValField = New eFunctions.valField

        '+ Fecha de ingreso
        If dInpdate = eRemoteDB.Constants.dtmNull Then
            Call lobjErrors.ErrorMessage(sCodispl, 9013)
        Else
            If lclsValField.ValDate(dInpdate, , eFunctions.valField.eTypeValField.onlyvalid) Then
                If dInpdate > Today Then
                    Call lobjErrors.ErrorMessage(sCodispl, 1002)
                End If
            End If
        End If

        '+ Apellido Paterno
        If sLastName = String.Empty Then
            Call lobjErrors.ErrorMessage(sCodispl, 2807, , , ": Apellido Paterno")
        Else
            If Not Regex.IsMatch(sLastName, sRx) Then
                Call lobjErrors.ErrorMessage(sCodispl, 2229, , eFunctions.Errors.TextAlign.LeftAling, "Apellido Paterno: ")
            End If
        End If

        '+ Apellido Materno
        If tctLastname2 = String.Empty Then
            Call lobjErrors.ErrorMessage(sCodispl, 2807, , , ": Apellido Materno")
        Else
            If Not Regex.IsMatch(tctLastname2, sRx) Then
                Call lobjErrors.ErrorMessage(sCodispl, 2229, , eFunctions.Errors.TextAlign.LeftAling, "Apellido Materno: ")
            End If
        End If


        '+ Nombres
        If sFirstName = String.Empty Then
            Call lobjErrors.ErrorMessage(sCodispl, 2207)
        Else
            If Not Regex.IsMatch(sFirstName, sRx) Then
                Call lobjErrors.ErrorMessage(sCodispl, 2229, , eFunctions.Errors.TextAlign.LeftAling, "Nombres: ")
            End If
        End If

        '+ Nacionalidad
        If nNationality = 0 Or nNationality = eRemoteDB.Constants.intNull Then
            Call lobjErrors.ErrorMessage(sCodispl, 55740)
        End If

        '+ Estado civil
        If nCivilsta = 0 Or nCivilsta = eRemoteDB.Constants.intNull Then
            Call lobjErrors.ErrorMessage(sCodispl, 2048)
        End If

        '+Sexo
        If sSexclien = "" Or sSexclien = "0" Then
            Call lobjErrors.ErrorMessage(sCodispl, 2007)
        End If


        '+ Fecha de nacimiento
        nValue = 0

        If dBirthdat <> eRemoteDB.Constants.dtmNull Then
            If Not lclsValField.ValDate(dBirthdat, , eFunctions.valField.eTypeValField.onlyvalid) Then
                Call lobjErrors.ErrorMessage(sCodispl, 2079)
            Else
                If dBirthdat > Today Then
                    Call lobjErrors.ErrorMessage(sCodispl, 2208)
                Else
                    If dInpdate <> eRemoteDB.Constants.dtmNull Then
                        If dBirthdat > dInpdate Then
                            Call lobjErrors.ErrorMessage(sCodispl, 2073)
                        End If
                    End If
                End If
            End If
        Else
            Call lobjErrors.ErrorMessage(sCodispl, 55696)
        End If

        '+ Licencia de conducir - Fecha
        nValue = 0

        If dDriverdat <> eRemoteDB.Constants.dtmNull Then
            If Not lclsValField.ValDate(dDriverdat, , eFunctions.valField.eTypeValField.onlyvalid) Then
                Call lobjErrors.ErrorMessage(sCodispl, 2081)
            Else
                If dDriverdat > Today Then
                    Call lobjErrors.ErrorMessage(sCodispl, 2077)
                Else
                    If dBirthdat <> eRemoteDB.Constants.dtmNull Then
                        If dDriverdat <= dBirthdat Then
                            Call lobjErrors.ErrorMessage(sCodispl, 2023)
                        End If
                    End If
                End If
            End If
        End If

        '+ Licencia de conducir - N�mero
        '+ Se valida el n�mero de la licencia (S�lo se debe llenar si la fecha de la licencia est� llena)
        '+ El n�mero de la licencia debe estar llena
        If sLicence = String.Empty And dDriverdat <> eRemoteDB.Constants.dtmNull Then
            Call lobjErrors.ErrorMessage(sCodispl, 2210)
        End If

        '+ Fecha de muerte
        If dDeathdat <> eRemoteDB.Constants.dtmNull Then
            nValue = 0
            If Not lclsValField.ValDate(dDeathdat, , eFunctions.valField.eTypeValField.onlyvalid) Then
                Call lobjErrors.ErrorMessage(sCodispl, 2080)
            Else
                If dDeathdat > Today Then
                    Call lobjErrors.ErrorMessage(sCodispl, 2791)
                Else
                    If dInpdate <> eRemoteDB.Constants.dtmNull Then
                        If dDeathdat <= dInpdate Then
                            Call lobjErrors.ErrorMessage(sCodispl, 2211)
                        End If
                    End If
                    If dBirthdat <> eRemoteDB.Constants.dtmNull Then
                        If dDeathdat < dBirthdat Then
                            Call lobjErrors.ErrorMessage(sCodispl, 2024)
                        End If
                    End If
                End If
            End If
        End If

        '+ Fecha de matrimonio,
        '+     Si es soltero NO debe tener fecha de matrimonio
        If nCivilsta = 2 Then
            If dWedd <> eRemoteDB.Constants.dtmNull Then
                Call lobjErrors.ErrorMessage(sCodispl, 55837)
            End If
        Else
            '+     Si la fecha de matrimonio es ingresada debe ser mayor a fecha de nacimiento
            If dWedd <> eRemoteDB.Constants.dtmNull And dWedd < dBirthdat Then
                Call lobjErrors.ErrorMessage(sCodispl, 55640)
            End If
        End If

        '+ Fecha de t�rmino de licencia
        If dDriverdat <> eRemoteDB.Constants.dtmNull And dDrivexpdat = eRemoteDB.Constants.dtmNull Then
            Call lobjErrors.ErrorMessage(sCodispl, 55641)
        End If
        If dDrivexpdat <> eRemoteDB.Constants.dtmNull And dDriverdat > dDrivexpdat Then
            Call lobjErrors.ErrorMessage(sCodispl, 55637)
        End If
        If dDrivexpdat <> eRemoteDB.Constants.dtmNull And dDrivexpdat < dBirthdat Then
            Call lobjErrors.ErrorMessage(sCodispl, 55638)
        End If
        If dDrivexpdat <> eRemoteDB.Constants.dtmNull And dInpdate > dDrivexpdat Then
            Call lobjErrors.ErrorMessage(sCodispl, 55639)
        End If

        insValBC001N = lobjErrors.Confirm

insValBC001N_Err:
        If Err.Number Then
            insValBC001N = "InsValBC001N: " & Err.Description
        End If
        'UPGRADE_NOTE: Object lobjErrors may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        lobjErrors = Nothing
        'UPGRADE_NOTE: Object lclsValField may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        lclsValField = Nothing
        On Error GoTo 0
    End Function
	
	'% insPostBC007S: Realiza las actualizaciones de la transaccion
	Public Function InsPostBC007S(ByVal sClient As String, ByVal nWeight As Double, ByVal nHeight As Double, ByVal sSport_cad As String, ByVal sHobby_cad As String, ByVal nUsercode As Integer) As Boolean
		Dim lobjClient As eClient.Client
		Dim lclsClientWin As ClientWin
		Dim lclsSport As Sport
		Dim lclsHobby As Hobby
		Dim lblnIndwin As Object
		
		On Error GoTo InsPostBC007S_Err
		lobjClient = New eClient.Client
		lclsClientWin = New ClientWin
		lclsSport = New Sport
		lclsHobby = New Hobby
		
		lblnIndwin = False
		
		InsPostBC007S = lobjClient.UpdateBC007S(sClient, nWeight, nHeight)
		If nWeight <> eRemoteDB.Constants.intNull Or nHeight <> eRemoteDB.Constants.intNull Then
			lblnIndwin = InsPostBC007S
		End If
		
		InsPostBC007S = lclsSport.InsPostBC007S(sSport_cad, sClient, nUsercode)
		If sSport_cad <> String.Empty And lblnIndwin = False Then
			lblnIndwin = InsPostBC007S
		End If
		
		InsPostBC007S = lclsHobby.InsPostBC007S(sHobby_cad, sClient, nUsercode)
		If sHobby_cad <> String.Empty And lblnIndwin = False Then
			lblnIndwin = InsPostBC007S
		End If
		
		lclsClientWin.insUpdClient_win(sClient, "BC007S", IIf(lblnIndwin, "2", "1"))
		
InsPostBC007S_Err: 
		If Err.Number Then
			InsPostBC007S = False
		End If
		'UPGRADE_NOTE: Object lobjClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lobjClient = Nothing
		'UPGRADE_NOTE: Object lclsClientWin may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClientWin = Nothing
		'UPGRADE_NOTE: Object lclsSport may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsSport = Nothing
		'UPGRADE_NOTE: Object lclsHobby may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsHobby = Nothing
		
		On Error GoTo 0
	End Function
	
	'% insPostBC801: Actualiza los campos de invalidez
	Public Function insPostBC801(ByVal sClient As String, ByVal nDisability As Integer, ByVal nIncapacity As Integer, ByVal dIncapacity As Date, ByVal nIncap_cod As Integer, ByVal nUsercode As Integer) As Boolean
		Dim lobjClient As Client
		Dim lclsClientWin As ClientWin
		Dim lblnIndwin As Object
		
		On Error GoTo insPostBC801_err
		lobjClient = New Client
		lclsClientWin = New ClientWin
		
		lblnIndwin = False
		
		insPostBC801 = lobjClient.UpdateBC801(sClient, nDisability, nIncapacity, dIncapacity, nIncap_cod, nUsercode)
		
		If nDisability <> eRemoteDB.Constants.intNull Or nIncapacity <> eRemoteDB.Constants.intNull Or dIncapacity <> eRemoteDB.Constants.dtmNull Or nIncap_cod <> eRemoteDB.Constants.intNull Then
			lblnIndwin = insPostBC801
		End If
		
		lclsClientWin.insUpdClient_win(sClient, "BC801", IIf(lblnIndwin, "2", "1"))
		
insPostBC801_err: 
		If Err.Number Then
			insPostBC801 = False
		End If
		On Error GoTo 0
		'UPGRADE_NOTE: Object lobjClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lobjClient = Nothing
		'UPGRADE_NOTE: Object lclsClientWin may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClientWin = Nothing
	End Function
	
	'% insPostBC007M: Realiza las actualizaciones de la transaccion
	Public Function insPostBC007M(ByVal sClient As String, ByVal nEconomic_l As Integer, ByVal nHouse_type As Integer, ByVal nQ_child As Integer, ByVal nQ_cars As Integer, ByVal nClass As Integer) As Boolean
		Dim lobjClient As eClient.Client
		Dim lclsClientWin As ClientWin
		
		On Error GoTo insPostBC007M_err
		lclsClientWin = New ClientWin
		lobjClient = New eClient.Client
		
		insPostBC007M = lobjClient.UpdateBC007M(sClient, nEconomic_l, nHouse_type, nQ_child, nQ_cars, nClass)
		
		If nEconomic_l = eRemoteDB.Constants.intNull And nHouse_type = eRemoteDB.Constants.intNull And nQ_child = eRemoteDB.Constants.intNull And nQ_cars = eRemoteDB.Constants.intNull And nClass = eRemoteDB.Constants.intNull Then
			insPostBC007M = False
		End If
		
		lclsClientWin.insUpdClient_win(sClient, "BC007M", IIf(insPostBC007M, "2", "1"))
		
insPostBC007M_err: 
		If Err.Number Then
			insPostBC007M = False
		End If
		'UPGRADE_NOTE: Object lobjClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lobjClient = Nothing
		'UPGRADE_NOTE: Object lclsClientWin may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClientWin = Nothing
		On Error GoTo 0
    End Function


    '% insPostBC007P: Realiza las actualizaciones de la transaccion
    Public Function insPostBC007P(ByVal sClient As String, ByVal sDigit As String, ByVal TypeOfPoliticalOffice As String, ByVal GrantDate As Date, ByVal EndDate As Date) As Boolean
        Dim lobjClient As eClient.Client
        Dim lclsClientWin As ClientWin

        On Error GoTo insPostBC007P_err
        lclsClientWin = New ClientWin
        lobjClient = New eClient.Client

        insPostBC007P = lobjClient.UpdateBC007P(sClient, sDigit, TypeOfPoliticalOffice, GrantDate, EndDate)

        If TypeOfPoliticalOffice = eRemoteDB.Constants.intNull And GrantDate = eRemoteDB.Constants.dtmNull Then
            insPostBC007P = False
        End If

        lclsClientWin.insUpdClient_win(sClient, "BC007P", IIf(insPostBC007P, "2", "1"))

insPostBC007P_err:
        If Err.Number Then
            insPostBC007P = False
        End If
        'UPGRADE_NOTE: Object lobjClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        lobjClient = Nothing
        'UPGRADE_NOTE: Object lclsClientWin may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        lclsClientWin = Nothing
        On Error GoTo 0
    End Function

    '% insPostBC001N: Se realiza la actualizaci�n de los datos
    Public Function insPostBC001N(ByVal sClient As String, ByVal dInpdate As Date, ByVal sCuit As String, ByVal sLastName As String, ByVal sFirstName As String, ByVal nCivilsta As Integer, ByVal sSexclien As String, ByVal nTitle As Integer, ByVal nNationality As Integer, ByVal nSpecialit As Integer, ByVal dBirthdat As Date, ByVal dDriverdat As Date, ByVal sLicence As String, ByVal dDeathdat As Date, ByVal sCredit_card As String, ByVal sBlockade As String, ByVal sLastname2 As String, ByVal nArea As Integer, ByVal dDrivexpdat As Date, ByVal nTypDriver As Integer, ByVal nLimitdriv As Integer, ByVal nHealth_org As Integer, ByVal nAfp As Integer, ByVal dWedd As Date, ByVal sBill_ind As String, ByVal nUsercode As Integer, ByVal dRetirement As Date, ByVal dIndependant As Date, ByVal dDependant As Date, ByVal sSmoking As String,
                                  ByVal sFatca As String, ByVal sPEP As String, ByVal sUsPerson As String, ByVal sCRS As String) As Boolean
        Dim lclsClient As Client
        Dim lclsClientWin As ClientWin

        lclsClient = New Client

        '+ Se actualizan los datos del cliente

        '+ [APV2] Certificado 24 Movimiento Anual cuentas de APV por RUT

        insPostBC001N = lclsClient.UpdateBC001N(sClient, dInpdate, sCuit, sLastName, sFirstName, nCivilsta, sSexclien, nTitle, nNationality, nSpecialit, dBirthdat, dDriverdat, sLicence, sCredit_card, sBlockade, dDeathdat, sLastname2, nArea, dDrivexpdat, nTypDriver, nLimitdriv, nHealth_org, nAfp, dWedd, sBill_ind, dRetirement, dIndependant, dDependant, sSmoking, sFatca, sPEP, sUsPerson, nUsercode, sCRS)
        'UPGRADE_NOTE: Object lclsClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        lclsClient = Nothing

        If insPostBC001N Then
            lclsClientWin = New ClientWin
            Call lclsClientWin.insUpdClient_win(sClient, "BC001N", "2", , , nUsercode)
            'UPGRADE_NOTE: Object lclsClientWin may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            lclsClientWin = Nothing
        End If
    End Function

    '% insPostBC001J_K: Se realiza la actualizaci�n de los datos
    Public Function insPostBC001J_K(ByVal sClient As String, ByVal dInpdate As Date, ByVal sCliename As String, ByVal sLegalname As String, ByVal nSpeciality As Integer, ByVal sCredit_card As String, ByVal dBirthdat As Date, ByVal nEmpl_qua As Integer, ByVal nInvoicing As Integer, ByVal sBill_ind As String, ByVal sBlockade As String, ByVal nComp_Type As String, ByVal sPEP As String, ByVal sUsperson As String) As Boolean
        Dim lclsClient As Client
        Dim lclsClientWin As ClientWin
        Dim lnInvoicing As Double

        On Error GoTo insPostBC001J_K_err
        lclsClient = New Client
        insPostBC001J_K = lclsClient.UpdateBC001J(sClient, dInpdate, sCliename, sLegalname, nSpeciality, sCredit_card, dBirthdat, nEmpl_qua, nInvoicing, sBill_ind, sBlockade, CInt(nComp_Type), sPEP, sUsperson)

        If insPostBC001J_K Then
            lclsClientWin = New ClientWin
            Call lclsClientWin.insUpdClient_win(sClient, "BC001J", "2")
        End If


insPostBC001J_K_err:
        If Err.Number Then
            insPostBC001J_K = False
        End If
        'UPGRADE_NOTE: Object lclsClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        lclsClient = Nothing
        'UPGRADE_NOTE: Object lclsClientWin may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        lclsClientWin = Nothing
        On Error GoTo 0
    End Function
	
	'% insPostBC014: Se realiza la actualizaci�n de los datos
	Public Function insPostBC014(ByVal Action As String, ByVal sClient As String, ByVal dFinanDate As Date, ByVal nConcept As Integer, Optional ByVal nUnits As Integer = 0, Optional ByVal nNotenum As Integer = 0, Optional ByVal nCurrency As Integer = 0, Optional ByVal nAmount As Double = 0, Optional ByVal nFinanStat As Integer = 0, Optional ByVal nUsercode As Integer = 0) As Boolean
		Dim lclsFinanc_cli As Financ_Cli
		Dim lclsClientWin As ClientWin
		Dim lcolFinanc_clis As Financ_Clis
		
		lclsFinanc_cli = New Financ_Cli
		With lclsFinanc_cli
			.nUsercode = nUsercode
			.sClient = sClient
			.dFinanDate = dFinanDate
			.nConcept = nConcept
			.nUnits = nUnits
			.nNotenum = nNotenum
			.nCurrency = nCurrency
			.nAmount = nAmount
			.nFinanStat = nFinanStat
			
			Select Case Action
				Case "Add"
					insPostBC014 = .Add
				Case "Update"
					insPostBC014 = .Update
				Case "Delete"
					insPostBC014 = .Delete
			End Select
			
			If insPostBC014 Then
				lclsClientWin = New ClientWin
				lcolFinanc_clis = New Financ_Clis
				If lcolFinanc_clis.Find(sClient) Then
					Call lclsClientWin.insUpdClient_win(sClient, "BC014", "2")
				Else
					Call lclsClientWin.insUpdClient_win(sClient, "BC014", "1")
				End If
				'UPGRADE_NOTE: Object lcolFinanc_clis may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
				lcolFinanc_clis = Nothing
				'UPGRADE_NOTE: Object lclsClientWin may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
				lclsClientWin = Nothing
			End If
		End With
		'UPGRADE_NOTE: Object lclsFinanc_cli may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsFinanc_cli = Nothing
	End Function
	
	'% insValBC001JContac: realiza las validaciones de los campos del grid de Contactos
	Public Function insValBC001JContac(ByVal Action As String, ByVal sCodispl As String, ByVal nValue As Integer, ByVal sClient As String, ByVal sClientr As String, ByVal nOrder As String, ByVal nPosition As String) As String
		Dim lobjErrors As eFunctions.Errors
		Dim lclsClient As eClient.Client
		Dim lclsContacCli As eClient.Contac_cli
		Dim lAction As Integer
		Dim mvarClientType As Client.eClientType
		Dim lblnFinc As Boolean
		
		On Error GoTo insValBC001JContac_Err
		
		lclsContacCli = New eClient.Contac_cli
		lclsClient = New eClient.Client
		lobjErrors = New eFunctions.Errors
		
		Select Case Action
			Case "Add"
				lAction = 1
				
			Case "Update"
				lAction = 2
				
			Case "Delete"
				lAction = 3
		End Select
		
		'+ sClient
		
		If sClientr = String.Empty Then
			Call lobjErrors.ErrorMessage(sCodispl, 2001)
		Else
			sClientr = lclsClient.ExpandCode(UCase(sClientr))
			If Not lclsClient.Find(sClientr) Then
				Call lobjErrors.ErrorMessage(sCodispl, 2215)
			Else
				If lclsClient.nPerson_typ <> 1 Then
					Call lobjErrors.ErrorMessage(sCodispl, 2216)
				Else
					If lclsClient.dDeathdat <> eRemoteDB.Constants.dtmNull Then
						If lclsClient.dDeathdat <= Today Then
							Call lobjErrors.ErrorMessage(sCodispl, 2051)
						End If
					End If
					'+ Se valida que el cliente exista en ContacCli
					If Action = "Add" Then
						If lclsContacCli.Find(sClient, sClientr, Today) Then
							Call lobjErrors.ErrorMessage(sCodispl, 2111)
						End If
					End If
				End If
			End If
		End If
		
		'+ nOrder
		If nOrder = "0" Or nOrder = String.Empty Then
			Call lobjErrors.ErrorMessage(sCodispl, 2213)
		Else
			If Action = "Add" Then
				If lclsContacCli.FindOrder(sClient, nOrder) Then
					Call lobjErrors.ErrorMessage(sCodispl, 2214)
				End If
			End If
		End If
		
		'+  nPosition
		If (nOrder <> "0" Or nOrder <> String.Empty) And (nPosition = "0" Or nPosition = String.Empty) Then
			Call lobjErrors.ErrorMessage(sCodispl, 2805)
		End If
		
		insValBC001JContac = lobjErrors.Confirm
		
insValBC001JContac_Err: 
		If Err.Number Then
			insValBC001JContac = "InsValBC001JContac: " & Err.Description
		End If
		'UPGRADE_NOTE: Object lobjErrors may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lobjErrors = Nothing
		'UPGRADE_NOTE: Object lclsClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClient = Nothing
		'UPGRADE_NOTE: Object lclsContacCli may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsContacCli = Nothing
		On Error GoTo 0
	End Function
	
	'% insValBC001J_K: realiza las validaciones de los campos del grid de Contactos
	Public Function insValBC001J_K(ByVal sCodispl As String, ByRef nValue As Integer, ByVal nAction As Integer, ByVal nPersonType As Integer, ByVal dInpdate As String, ByVal sCliename As String, ByVal nSpeciality As String, ByVal dBirthdat As String, ByVal sLegalname As String, ByRef nBranch As Integer, ByRef nProduct As Integer, ByVal nRole As Integer, ByVal nEmpl_qua As Integer) As String
		Dim lobjErrors As eFunctions.Errors
		
		lobjErrors = New eFunctions.Errors
		
		On Error GoTo insValBC001J_K_Err
		
		'+ Fecha de ingreso
		If dInpdate = String.Empty Then
			Call lobjErrors.ErrorMessage(sCodispl, 9013)
		Else
			If CDate(dInpdate) > Today Then
				Call lobjErrors.ErrorMessage(sCodispl, 1002)
			End If
		End If
		
		'+ Se realiza la vaidaci�n del campo Nombre legal
		If sLegalname = String.Empty Then
			Call lobjErrors.ErrorMessage(sCodispl, 55645)
		End If
		
		'+ Se realiza la vaidaci�n del campo Nombre
		If sCliename = String.Empty Then
			Call lobjErrors.ErrorMessage(sCodispl, 2004)
		End If
		
		
		'+ vaidaci�n del campo Inicio de Operaciones
		If dBirthdat = String.Empty Then
			Call lobjErrors.ErrorMessage(sCodispl, 2088)
		Else
			If CDate(dBirthdat) > Today Then
				Call lobjErrors.ErrorMessage(sCodispl, 2089)
			End If
		End If
		
		'+ vaidaci�n del campo empledos
		If nEmpl_qua = eRemoteDB.Constants.intNull Or nEmpl_qua = 0 Then
			Call lobjErrors.ErrorMessage(sCodispl, 55856)
		End If
		
		insValBC001J_K = lobjErrors.Confirm
		
insValBC001J_K_Err: 
		If Err.Number Then
			insValBC001J_K = "InsValBC001J_K: " & Err.Description
		End If
		'UPGRADE_NOTE: Object lobjErrors may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lobjErrors = Nothing
		
		On Error GoTo 0
	End Function
	
	'% insPostBC001J: Se realiza la actualizaci�n de los datos
	Public Function insPostBC001J(ByVal Action As String, ByVal sClient As String, ByVal sClientr As String, Optional ByVal nOrder As String = "", Optional ByVal nPosition As String = "", Optional ByVal sNewClientr As String = "", Optional ByVal nUsercode As String = "") As Boolean
		Dim lclsContac_cli As Contac_cli
		Dim lclsClientWin As ClientWin
		Dim lclsClient As Client
		
		On Error GoTo insPostBC001J_Err
		
		lclsClient = New Client
		sClient = lclsClient.ExpandCode(UCase(sClient))
		sClientr = lclsClient.ExpandCode(UCase(sClientr))
		'UPGRADE_NOTE: Object lclsClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClient = Nothing
		
		lclsContac_cli = New Contac_cli
		With lclsContac_cli
			.sClient = sClient
			.dEffecdate = Today
			If nOrder = String.Empty Then
				.nOrder = eRemoteDB.Constants.intNull
			Else
				.nOrder = CShort(nOrder)
			End If
			
			If nUsercode = String.Empty Then
				.nUsercode = eRemoteDB.Constants.intNull
			Else
				.nUsercode = CShort(nUsercode)
			End If
			If nPosition = String.Empty Then
				.nPosition = eRemoteDB.Constants.intNull
			Else
				.nPosition = CShort(nPosition)
			End If
			
			Select Case Action
				Case "Add"
					.sClientr = sClientr
					.sNewClientr = sClientr
					insPostBC001J = .Add
				Case "Delete"
					.sClient = sClient
					.sNewClientr = sClientr
					insPostBC001J = .Delete
				Case "Update"
					If sNewClientr = "" Or sNewClientr Is System.DBNull.Value.ToString Then
						sNewClientr = sClientr
					End If
					.sClientr = sNewClientr
					.sNewClientr = sNewClientr
					insPostBC001J = .Update
			End Select
            If insPostBC001J Then
                lclsClientWin = New ClientWin
                Call lclsClientWin.insUpdClient_win(sClient, "BC001J", "2")
            End If
		End With
		
insPostBC001J_Err: 
		insPostBC001J = insError(insPostBC001J)
		'UPGRADE_NOTE: Object lclsClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClient = Nothing
		'UPGRADE_NOTE: Object lclsClientWin may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClientWin = Nothing
		'UPGRADE_NOTE: Object lclsContac_cli may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsContac_cli = Nothing
	End Function
	
	'% insValSCA002: se realizan las validaciones puntuales y masivas de la ventana de Notas
	Public Function insValSCA002(ByVal sCodispl As String, ByVal TypeBehaviour As String, ByVal dCreaDate As String, ByVal dLimitDate As String, ByVal sDescript As String, Optional ByVal tDs_text As String = "", Optional ByVal sSource As String = "") As Boolean
		Dim lstrSource As String
		Dim lobjErrors As eFunctions.Errors
		Dim lclsQuery As eRemoteDB.Query
		
		On Error GoTo insValSCA002_Err
		lobjErrors = New eFunctions.Errors
		
		'+ Valor por defecto (por si no lo encuentra en Table563, nCodigint=31)
		lstrSource = "Ubicaci�n"
		
		insValSCA002 = True
		
		'+ Validacion del campo Fecha l�mite
		'+ Debe ser mayor a la fecha de creaci�n
		If dCreaDate >= dLimitDate Then
			Call lobjErrors.ErrorMessage(sCodispl, 2086)
		End If
		'   End If
		
		'+ Validacion del campo Descripci�n - Debe estar lleno
		If Trim(sDescript) = String.Empty Then
			Call lobjErrors.ErrorMessage(sCodispl, 3872)
		End If
		
		'+ Validacion del campo Detalle - El campo Detalle debe estar lleno
		Select Case TypeBehaviour
			Case "Note"
				If Trim(tDs_text) = String.Empty Then
					Call lobjErrors.ErrorMessage(sCodispl, 3873)
				End If
			Case "Image"
				'+ Si se est� tratando con im�genes, el campo Ubicaci�n debe estar lleno
				If Trim(sSource) = String.Empty Then
					lclsQuery = New eRemoteDB.Query
					With lclsQuery
						If .OpenQuery("Table563", "sDescript", "nCodigint=31") Then
							lstrSource = .FieldToClass("sDescript")
							.CloseQuery()
						End If
					End With
					Call lobjErrors.ErrorMessage(sCodispl, 1925,  , eFunctions.Errors.TextAlign.LeftAling, lstrSource)
				End If
		End Select
		
		insValSCA002 = CBool(lobjErrors.Confirm)
		
insValSCA002_Err: 
		If Err.Number Then
			insValSCA002 = False
		End If
		'UPGRADE_NOTE: Object lobjErrors may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lobjErrors = Nothing
		'UPGRADE_NOTE: Object lclsQuery may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsQuery = Nothing
		On Error GoTo 0
	End Function
	
	'% DeleteSequence: se elimina la informaci�n relacionada a un cliente
	Public Function DeleteSequence(ByVal sClient As String, ByVal nUsercode As String) As Boolean
		Dim llngCount As Integer
		Dim llngPos As Integer
		Dim lstrCodispl As String
		Dim lblnStatus As Boolean
		Dim lclsClient_win As ClientWin
		Dim lclsRelations As Relation
		Dim lobjClient As Object
		Dim lrecRecordset As eRemoteDB.Execute
		
		'+ Variables para el manejo de la secuencia de ventanas del cliente
		Dim lstrV_conclien As Object
		Dim lstrV_winclien As Object
		
		lrecRecordset = New eRemoteDB.Execute
		lclsClient_win = New ClientWin
		lclsRelations = New Relation
		
		On Error GoTo DeleteSequence_Err
		
		If lclsClient_win.Find(sClient, Today) Then
			lblnStatus = True
			lstrV_conclien = Trim(lclsClient_win.sV_ConClien)
			lstrV_winclien = Trim(lclsClient_win.sV_WinClien)
			
			'+ Definici�n de par�metros para stored procedure 'insudb.delClient_win'
			'+ Informaci�n le�da el 26/11/99 13:55:59
			
			With lrecRecordset
				.StoredProcedure = "delClient_win"
				.Parameters.Add("sClient", sClient, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbVarChar, 14, 0, 0, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
				lblnStatus = .Run(False)
			End With
			
			llngCount = Len(lstrV_conclien)
			
			For llngPos = 1 To llngCount
				
				'+ Si la ventana tiene contenido se elimina la informaci�n incluida en la base de datos.
				
				If Mid(lstrV_conclien, llngPos, 1) = "2" Then
					lstrCodispl = Trim(Mid(lstrV_winclien, (llngPos - 1) * 8 + 1, 8))
					Select Case lstrCodispl
						Case "BC001J"
							'+ Definici�n de par�metros para stored procedure 'insudb.delContac_cli'
							'+ Informaci�n le�da el 26/11/99 13:58:15
							With lrecRecordset
								.StoredProcedure = "delContac_cli"
								.Parameters.Add("sClient", sClient, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbVarChar, 14, 0, 0, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
								lblnStatus = .Run(False)
							End With
							
						Case "BC002"
							lblnStatus = lclsRelations.Delete_Relations(sClient, CShort(nUsercode))
							
						Case "SCA101"
							'+ Borrar la direcci�n y tel�fono 'Comerciales'
							
							'+ Definici�n de par�metros para stored procedure 'insudb.delAddress'
							'+ Informaci�n le�da el 26/11/99 14:00:25
							
							With lrecRecordset
								.StoredProcedure = "delAddress"
								.Parameters.Add("nRecowner", eGeneralForm.Address.eTypeRecOwner.clngClientAddress, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbInteger, 0, 0, 10, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
								.Parameters.Add("sKeyAddress", CStr(eGeneralForm.Addresss.eTypeRecType.cstrComercial) & sClient, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbVarChar, 20, 0, 0, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
								lblnStatus = .Run(False)
							End With
							'+ Borrar la direcci�n y tel�fono 'Particulares'
							
							'+ Definici�n de par�metros para stored procedure 'insudb.delAddress'
							'+ Informaci�n le�da el 26/11/99 14:00:25
							
							With lrecRecordset
								.StoredProcedure = "delAddress"
								.Parameters.Add("nRecowner", eGeneralForm.Address.eTypeRecOwner.clngClientAddress, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbInteger, 0, 0, 10, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
								.Parameters.Add("sKeyAddress", CStr(eGeneralForm.Addresss.eTypeRecType.cstrParticular) & sClient, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbVarChar, 20, 0, 0, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
								lblnStatus = .Run(False)
							End With
							
							'+ Borra la informaci�n financiera del cliente
						Case "BC014"
							'+ Definici�n de par�metros para stored procedure 'insudb.delFinanc_cli'
							'+ Informaci�n le�da el 01/09/2000 8:55:01
							
							With lrecRecordset
								.StoredProcedure = "delFinanc_cli"
								.Parameters.Add("sClient", sClient, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbVarChar, 14, 0, 0, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
								'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
								.Parameters.Add("dFinanDate", System.DBNull.Value, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbDBTimeStamp, 0, 0, 0, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
								'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
								.Parameters.Add("nConcept", System.DBNull.Value, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbInteger, 0, 0, 10, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
								lblnStatus = .Run(False)
							End With
							
							'+ Borra la informaci�n de la cuentas bancarias del cliente
						Case "BC013"
							lobjClient = New bk_account
							lblnStatus = lobjClient.DeleteAll(sClient)
							'UPGRADE_NOTE: Object lobjClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
							lobjClient = Nothing
							
							'+ Borra la informaci�n de la tarjetas de cr�dito del cliente
						Case "BC016"
							lobjClient = New cred_card
							lblnStatus = lobjClient.DeleteAll(sClient)
							'UPGRADE_NOTE: Object lobjClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
							lobjClient = Nothing
							
							'+ Borra la informaci�n de la domiciliaci�n del cliente
						Case "BC015"
							lobjClient = New Dir_debit_cli
							lblnStatus = lobjClient.DeleteAll(sClient)
							'UPGRADE_NOTE: Object lobjClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
							lobjClient = Nothing
							
					End Select
				End If
				
				If Not lblnStatus Then
					Exit For
				End If
			Next llngPos
			If lblnStatus Then
				'+ Definici�n de par�metros para stored procedure 'insudb.delClient'
				'+ Informaci�n le�da el 26/11/99 14:03:51

                With lrecRecordset
                    .StoredProcedure = "delClient_all"
                    .Parameters.Add("sClient", sClient, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbVarchar, 14, 0, 0, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
                    lblnStatus = .Run(False)
                End With

				With lrecRecordset
					.StoredProcedure = "delClient"
					.Parameters.Add("sClient", sClient, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbVarChar, 14, 0, 0, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
					lblnStatus = .Run(False)
				End With
			End If
		End If
		
		DeleteSequence = lblnStatus
		
		'UPGRADE_NOTE: Object lrecRecordset may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lrecRecordset = Nothing
		'UPGRADE_NOTE: Object lclsClient_win may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClient_win = Nothing
		'UPGRADE_NOTE: Object lclsRelations may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsRelations = Nothing
		
DeleteSequence_Err: 
		If Err.Number Then
			DeleteSequence = False
		End If
		On Error GoTo 0
	End Function
	
	'% insValBC007M: se realizan las validaciones -puntuales y/o masivas- que se realizan a los
	'%               campos del frame.
	Public Function insValBC007M(ByVal nQChild As Integer, ByVal nQAuto As Integer, ByVal sClient As String) As String
		Dim lobjErrors As eFunctions.Errors
		Dim lvalField As eFunctions.valField
		Dim lclsClient As Client
		
		lobjErrors = New eFunctions.Errors
		lvalField = New eFunctions.valField
		lclsClient = New Client
		
		On Error GoTo insValBC007M_Err
		
		lvalField.objErr = lobjErrors
		
		'+ Validaci�n del campo HIJOS
		If nQChild <> eRemoteDB.Constants.intNull Then
			With lvalField
				.Descript = "Hijos: "
				Call .ValNumber(nQChild,  , eFunctions.valField.eTypeValField.onlyvalid)
			End With
			If nQChild > 50 Then
				Call lclsClient.Find(sClient)
				If lclsClient.nPerson_typ = 1 Then
					Call lobjErrors.ErrorMessage("BC007M", 55859)
				End If
			End If
		End If
		
		'+ Validaci�n del campo AUTOS
		If nQAuto <> eRemoteDB.Constants.intNull Then
			With lvalField
				.Descript = "Autos: "
				Call .ValNumber(nQAuto,  , eFunctions.valField.eTypeValField.onlyvalid)
			End With
			
			If nQAuto > 10 Then
				Call lclsClient.Find(sClient)
				If lclsClient.nPerson_typ = 1 Then
					Call lobjErrors.ErrorMessage("BC007M", 55857)
				End If
			End If
		End If
		
		insValBC007M = lobjErrors.Confirm
		
insValBC007M_Err: 
		If Err.Number Then
			insValBC007M = "InsValBC007M: " & Err.Description
		End If
		'UPGRADE_NOTE: Object lobjErrors may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lobjErrors = Nothing
		'UPGRADE_NOTE: Object lvalField may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lvalField = Nothing
		'UPGRADE_NOTE: Object lclsClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClient = Nothing
		On Error GoTo 0
	End Function

    '% insValBC007M: se realizan las validaciones -puntuales y/o masivas- que se realizan a los
    '%               campos del frame.
    Public Function insValBC007P(ByVal sClient As String, ByVal ntypepop As Integer, ByVal dGrantDate As Date, ByVal dEndDate As Date, Optional ByVal nPlaceOfBirth As Integer = 0, Optional ByVal nSNationality As Integer = 0, Optional nResidentFormer As Integer = 0, Optional sAddress As String = "", Optional ByVal sSSN As String = "", Optional ByVal sUsLegalPerson As String = "", Optional sUsItinNum As String = "", Optional sUsPhone As String = "", Optional sUsIrsind As String = "", Optional ByVal sUsAccount As String = "") As String


        Dim lobjErrors As eFunctions.Errors
        Dim lvalField As eFunctions.valField
        Dim lclsClient As Client
        Dim compara As Integer

        lobjErrors = New eFunctions.Errors
        lvalField = New eFunctions.valField
        lclsClient = New Client

        On Error GoTo insValBC007P_Err

        lvalField.objErr = lobjErrors

        Call lclsClient.Find(sClient)

        If lclsClient.sPEP = "1" Then
            '+ Validaci�n del campo cargo
            If ntypepop <> eRemoteDB.Constants.intNull Then
                If ntypepop = 98 Then
                    Call lobjErrors.ErrorMessage("BC007P", 55863)
                Else
                    With lvalField
                        .Descript = "Cargo: "
                        Call .ValNumber(ntypepop, , eFunctions.valField.eTypeValField.ValAll)
                    End With
                End If
            End If

            If ntypepop = eRemoteDB.Constants.intNull Then
                Call lobjErrors.ErrorMessage("BC007P", 55863)
            End If

            '+ Validaci�n del campo Fecha otorgamiento
            If dGrantDate = eRemoteDB.Constants.dtmNull Then
                With lvalField
                    .Descript = "Fecha otorgamiento: "
                    Call .ValDate(dGrantDate, , eFunctions.valField.eTypeValField.onlyvalid)
                End With

            End If

            If dGrantDate <> eRemoteDB.Constants.dtmNull Then
                With lvalField
                    .Descript = "Fecha otorgamiento: "
                    Call .ValDate(dGrantDate, , eFunctions.valField.eTypeValField.onlyvalid)
                End With

            End If

            '+ Validaci�n del campo Fecha fin
            If dEndDate <> eRemoteDB.Constants.dtmNull Then
                With lvalField
                    .Descript = "Fecha de termino: "
                    Call .ValDate(dEndDate, , eFunctions.valField.eTypeValField.onlyvalid)
                End With
                If dGrantDate <> eRemoteDB.Constants.dtmNull Then

                    compara = dEndDate.CompareTo(dGrantDate)

                    If compara < 0 Then
                        Call lobjErrors.ErrorMessage("BC007P", 21099)
                    End If

                End If
            End If
        Else
            If ntypepop = eRemoteDB.Constants.intNull Then
                ntypepop = 98
            End If
            'If dGrantDate = eRemoteDB.Constants.dtmNull Then
            '    dGrantDate = Date.Now
            'End If
        End If

        If lclsClient.sUsPerson = "1" Then

            If nPlaceOfBirth = eRemoteDB.Constants.intNull Then
                'debe indicar lugar de nacimiento
                Call lobjErrors.ErrorMessage("BC007P", 21120)
            End If

            If nResidentFormer = eRemoteDB.Constants.intNull Then
                'debe indicar pais anterior
                Call lobjErrors.ErrorMessage("BC007P", 21122)
            End If

            'If nSNationality = eRemoteDB.Constants.intNull Then
            '    'debe indicar nacionalidad de residencia anterior
            '    'Call lobjErrors.ErrorMessage("BC007P", 21121)
            'End If

            If sSSN = eRemoteDB.Constants.strNull And sUsItinNum = eRemoteDB.Constants.strNull Then
                'debe llenar al menos uno de los campos
                Call lobjErrors.ErrorMessage("BC007P", 21123)
            End If

            If sSSN <> eRemoteDB.Constants.strNull And sUsItinNum <> eRemoteDB.Constants.strNull Then
                'solo debe llenar solo uno de los campos
                Call lobjErrors.ErrorMessage("BC007P", 21124)
            End If
            If lclsClient.nNationality <> 254 And nPlaceOfBirth <> 254 And nResidentFormer <> 254 And nSNationality <> 254 Then
                'Un campo debe ser  Estados unidos
                Call lobjErrors.ErrorMessage("BC007P", 21125)
            End If

        End If

        'SE VALIDA QUE SE HAYA INGRESADO ALMENOS UN PAIS SI ES CRS
        If lclsClient.sCRS = "1" Then
            Dim mobjFiscalResidences As eClient.Fiscal_Residences
            mobjFiscalResidences = New Fiscal_Residences
            Dim Baux_bol As Boolean
            Baux_bol = mobjFiscalResidences.Find(lclsClient.sClient, Date.Now)
            If (Baux_bol = False) Then
                Call lobjErrors.ErrorMessage("BC007P", 90000521)
            End If
        End If



        insValBC007P = lobjErrors.Confirm

insValBC007P_Err:
        If Err.Number Then
            insValBC007P = "InsValBC007M: " & Err.Description
        End If
        'UPGRADE_NOTE: Object lobjErrors may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        lobjErrors = Nothing
        'UPGRADE_NOTE: Object lvalField may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        lvalField = Nothing
        'UPGRADE_NOTE: Object lclsClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        lclsClient = Nothing
        On Error GoTo 0
    End Function


	'% insValBC007S: se realizan las validaciones -puntuales y/o masivas- que se realizan a los
	'%               campos del frame.
	Public Function insValBC007S(ByVal nWeight As Double, ByVal nHeight As Double) As String
		Dim lobjErrors As eFunctions.Errors
		Dim lvalField As eFunctions.valField
		
		lobjErrors = New eFunctions.Errors
		lvalField = New eFunctions.valField
		
		On Error GoTo insValBC007S_Err
		
		lvalField.objErr = lobjErrors
		
		'+ Validaci�n del campo PESO
		If nWeight <> eRemoteDB.Constants.intNull Then
			With lvalField
				.Descript = "Peso: "
				Call .ValNumber(nWeight,  , eFunctions.valField.eTypeValField.onlyvalid)
			End With
		End If
		
		'+ Validaci�n del campo ALTURA
		If nHeight <> eRemoteDB.Constants.intNull Then
			With lvalField
				.Descript = "Altura: "
				Call .ValNumber(nHeight,  , eFunctions.valField.eTypeValField.onlyvalid)
			End With
		End If
		
		insValBC007S = lobjErrors.Confirm
		
		'UPGRADE_NOTE: Object lobjErrors may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lobjErrors = Nothing
		'UPGRADE_NOTE: Object lvalField may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lvalField = Nothing
		
insValBC007S_Err: 
		If Err.Number Then
			insValBC007S = "InsValBC007S: " & Err.Description
		End If
		On Error GoTo 0
	End Function
	
	'% insValBC801: se realizan las validaciones -puntuales y/o masivas- que se realizan a los
	'%              campos del frame.
	Public Function insValBC801(ByVal sClient As String, ByVal nDisability As Integer, ByVal nIncapacity As Integer, ByVal dIncapacity As Date, ByVal nIncap_cod As Integer) As String
		Dim lobjErrors As eFunctions.Errors
		Dim lclsClient As Client
		
		lobjErrors = New eFunctions.Errors
		lclsClient = New Client
		
		On Error GoTo insValBC801_Err
		
		With lobjErrors
			'+ Validaci�n del campo Tipo de Invalidez
			If nIncapacity = eRemoteDB.Constants.intNull Then
				.ErrorMessage("BC801", 55838)
			Else
				'+ Validaci�n del campo Fecha de Invalidez
				If dIncapacity = eRemoteDB.Constants.dtmNull Then
					'+ Si tipo de invalidez es distinto de "No inv�lido", debe estar lleno  55642
					If nIncapacity <> 3 Then
						lobjErrors.ErrorMessage("BC801", 55642)
					End If
				Else
					'+ Si tipo de invalidez es "No inv�lido", no debe tener valor  55839
					If nIncapacity = 3 Then
						lobjErrors.ErrorMessage("BC801", 55839)
					Else
						'+ La fecha de invalidez no puede ser mayor al dia
						If dIncapacity > Today Then
							lobjErrors.ErrorMessage("BC801", 55849)
						End If
						'+ Fecha de Invalidez Debe ser posterior a la fecha de nacimiento del cliente
						Call lclsClient.Find(sClient)
						If dIncapacity <= lclsClient.dBirthdat Then
							lobjErrors.ErrorMessage("BC801", 55644)
						End If
					End If
				End If
				'+ Validaci�n de causal de invalidez
				If nIncap_cod = eRemoteDB.Constants.intNull Then
					If nIncapacity <> 3 Then
						lobjErrors.ErrorMessage("BC801", 55643)
					End If
				Else
					If nIncapacity = 3 Then
						lobjErrors.ErrorMessage("BC801", 55840)
					End If
				End If
			End If
			insValBC801 = .Confirm
		End With
		
insValBC801_Err: 
		If Err.Number Then
			insValBC801 = "InsValBC801: " & Err.Description
		End If
		On Error GoTo 0
		'UPGRADE_NOTE: Object lobjErrors may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lobjErrors = Nothing
		'UPGRADE_NOTE: Object lclsClient may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClient = Nothing
	End Function
	
	'% ErrorDescript: Esta funci�n se utiliza para controlar el manejo de errores de los metodos del
	'%                tipo boolean.
	Public ReadOnly Property ErrorDescript() As String
		Get
			ErrorDescript = mstrError
			mstrError = String.Empty
		End Get
	End Property
	
	'% insError: Esta funci�n se encarga de realizar el manejo de los errores del sistema
	Private Function insError(ByRef bFunction As Boolean) As Boolean
		If Err.Number Then
			mstrError = Err.Description
			insError = False
		Else
			insError = bFunction
		End If
		On Error GoTo 0
	End Function
	
	'% Class_Initialize: Crea la colecci�n
	'UPGRADE_NOTE: Class_Initialize was upgraded to Class_Initialize_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
	Private Sub Class_Initialize_Renamed()
		mstrError = String.Empty
	End Sub
	Public Sub New()
		MyBase.New()
		Class_Initialize_Renamed()
	End Sub
	
	
	
	'%InsValBC008: Validaciones de la transacci�n(Folder)
	'%              Tabla de control de prima m�nima(BC008)
	Public Function InsValBC008(ByVal sCodispl As String, ByVal sAction As String, ByVal sClient As String, ByVal nIddoc_type As Integer, ByVal sIddoc As String, ByVal sIddoc_digit As String) As String
		Dim lclsErrors As eFunctions.Errors
		Dim lclsClient_IdDoc As Client_IdDoc
		
		On Error GoTo InsValBC008_Err
		lclsErrors = New eFunctions.Errors
		
		With lclsErrors
			'+Validar datos requeridos
			If sAction = "Add" Or sAction = "Update" Then
				If nIddoc_type = eRemoteDB.Constants.intNull Then
					.ErrorMessage(sCodispl, 10258,  , eFunctions.Errors.TextAlign.RigthAling, " - Tipo de documento")
				End If
				
				If sIddoc = String.Empty Then
					.ErrorMessage(sCodispl, 10258,  , eFunctions.Errors.TextAlign.RigthAling, " - C�digo")
				End If
			End If
			
			'+Validar que no se dupliquen registros
			If sAction = "Add" Then
				lclsClient_IdDoc = New Client_IdDoc
				If lclsClient_IdDoc.Find(sClient, nIddoc_type) Then
					.ErrorMessage(sCodispl, 12101)
				End If
				'UPGRADE_NOTE: Object lclsClient_IdDoc may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
				lclsClient_IdDoc = Nothing
			End If
			
			InsValBC008 = .Confirm
		End With
		
InsValBC008_Err: 
		If Err.Number Then
			InsValBC008 = "InsValBC008: " & Err.Description
		End If
		'UPGRADE_NOTE: Object lclsErrors may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsErrors = Nothing
		On Error GoTo 0
	End Function
	
	
	'%InsPostBC008: Ejecuta el post de la transacci�n
	'%               Tabla de control de prima m�nima(BC008)
	Public Function InsPostBC008(ByVal sAction As String, ByVal sClient As String, ByVal nIddoc_type As Integer, ByVal sIddoc As String, ByVal sIddoc_digit As String, ByVal nUsercode As Integer) As Boolean
		
		On Error GoTo InsPostBC008_Err
		
		Dim lclsClient_IdDoc As Client_IdDoc
		Dim lcolClient_IdDoc As Client_IdDocs
		Dim lclsClientWin As ClientWin
		Dim lblnExists As Boolean
		
		lclsClient_IdDoc = New Client_IdDoc
		
		With lclsClient_IdDoc
			.sClient = sClient
			.nIddoc_type = nIddoc_type
			.sIddoc = sIddoc
			.sIddoc_digit = sIddoc_digit
			.nUsercode = nUsercode
			
			Select Case sAction
				Case "Add"
					InsPostBC008 = lclsClient_IdDoc.Add
				Case "Update"
					InsPostBC008 = lclsClient_IdDoc.Update
				Case "Del"
					InsPostBC008 = lclsClient_IdDoc.Delete
			End Select
		End With
		'UPGRADE_NOTE: Object lclsClient_IdDoc may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		lclsClient_IdDoc = Nothing
		
		If InsPostBC008 Then
			lblnExists = False
			'+Si se elimin� un registro se ve si quedan m�s
			If sAction = "Del" Then
				lcolClient_IdDoc = New Client_IdDocs
				lblnExists = lcolClient_IdDoc.FindClient(sClient)
				'UPGRADE_NOTE: Object lcolClient_IdDoc may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
				lcolClient_IdDoc = Nothing
				'+Si no, debieran existir
			Else
				lblnExists = True
			End If
			
			lclsClientWin = New ClientWin
			If lblnExists Then
				Call lclsClientWin.insUpdClient_win(sClient, "BC008", "2")
			Else
				Call lclsClientWin.insUpdClient_win(sClient, "BC008", "1")
			End If
			'UPGRADE_NOTE: Object lclsClientWin may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
			lclsClientWin = Nothing
		End If
		
InsPostBC008_Err: 
		If Err.Number Then
			InsPostBC008 = False
		End If
		On Error GoTo 0
	End Function
End Class






