﻿'---------------------------------------------------------------------------------------------------
' <generated>
'     This code was generated by Form Designer v7.3.36.1 at 2020-03-18 10:15:35 AM model release 12, Form Generator v1.0.37.37
'     
'     Changes to this file may cause incorrect behavior and will be lost if the code is regenerated.
' </generated>
'---------------------------------------------------------------------------------------------------
      
#Region "using"

Imports System.Data
Imports System.Globalization
Imports System.Net
Imports System.Runtime.Serialization
Imports System.Web.Script.Services
Imports System.Web.Services
Imports InMotionGIT.Common.Helpers
Imports InMotionGIT.Common.Proxy
Imports InMotionGIT.FrontOffice.Support

#End Region

Namespace dli.forms

    Public Class UProfileActions
        Inherits System.Web.UI.Page

#Region "Actions Methods"

       <WebMethod(EnableSession:=True)>
        Public Shared Function Initialization(id As String, urlid As String, fromid As String) As InMotionGIT.FrontOffice.Support.DataType.ServerActionResult
            
            Dim instance As New EntryData With {.InstanceFormId = id}
            Dim resultData As New InMotionGIT.FrontOffice.Support.DataType.ServerActionResult
            Dim currentAction As String = String.Empty
            
            Dim UProfileParametersInstance As UProfileParameters = Nothing

            
            Try
                InMotionGIT.FASI.Support.Authentication.AuthorizationProcess("*")
                
                If id.IsEmpty AndAlso urlid.IsEmpty Then
                    instance.InstanceFormId = System.Guid.NewGuid().ToString
                    
                    With instance

                    End With                
                    
                    UProfileParametersInstance = EntryDataToClass(UProfileParametersInstance, instance)
                    
                    

                Else       
                    instance.InstanceFormId = id.IfEmpty(urlid)
                    UProfileParametersInstance = RetrieveFormInformationFromSession(instance.InstanceFormId)
         
                    If IsNothing(UProfileParametersInstance) then
                        UProfileParametersInstance = EntryDataToClass(UProfileParametersInstance, instance)                        
                    End If
                    
                    
                End If

                HttpContext.Current.Session(String.Format(CultureInfo.InvariantCulture, "Form.{0}.trace", IO.Path.GetFileNameWithoutExtension("Page.AppRelativeVirtualPath"))) = String.Empty

                If id.IsEmpty AndAlso urlid.IsEmpty Then
                    Form_Initialization(currentAction, UProfileParametersInstance, resultData)
                End If


                instance = ClassToEntryData(instance, UProfileParametersInstance) 
		        StoreFormInformationOnSession(UProfileParametersInstance)
                
                                
                With resultData
                    .Success = True
                    .Data = New With {.Instance = instance, .LookUps = LoadLookupsList(UProfileParametersInstance)}
                End With

            Catch ex As Exception
                resultData = InMotionGIT.FrontOffice.Support.ExceptionHandler.ProcessServerAction(ex, "UProfile", "Initialization", currentAction)
            End Try
            
            Return resultData
        End Function
  

        Public Shared Function LoadLookupsList(UProfileParametersInstance As UProfileParameters) As List(Of InMotionGIT.Common.DataType.LookUpPackage)
            Dim result As New List(Of InMotionGIT.Common.DataType.LookUpPackage)
            
            Dim dataFactory As New DataManagerFactory("PackageExecuteToLookUp", "LOOKUPS", "")
            Dim dataCommand As InMotionGIT.Common.Services.Contracts.DataCommand = Nothing
            
            dataCommand = dataFactory.AddCommand(String.Format(CultureInfo.CurrentCulture, "SELECT  TABLE66.NCOUNTRY, TABLE66.SDESCRIPT FROM TABLE66 TABLE66    WHERE NOT TABLE66.SDESCRIPT IS NULL ORDER BY SDESCRIPT", ""), New InMotionGIT.Common.DataType.LookUpValue With {.Code = "NCOUNTRY", .Description = "SDESCRIPT"}, "Country", "TABLE66", "Linked.LatCombined")
            
            result = dataFactory.PackageExecuteToLookUp()
	
            Return result
        End Function


        <WebMethod(EnableSession:=True)>
        Public Shared Function btnSaClick(instance As EntryData) As InMotionGIT.FrontOffice.Support.DataType.ServerActionResult
            
            Dim resultData As New InMotionGIT.FrontOffice.Support.DataType.ServerActionResult
            Dim UProfileParametersInstance As UProfileParameters = Nothing
            Dim UserInfo As InMotionGIT.Membership.Providers.MemberContext = Nothing
            Dim formContext As InMotionGIT.Common.Contracts.Context = Nothing
            Dim selectDataTableItem As DataTable = Nothing
            Dim currentAction As String = String.Empty
            Dim messageAction As String = String.Empty
            Dim parametersDictionary As Dictionary(Of String, Object) = Nothing
            Dim WorkflowInArguments As Dictionary(Of String, Object) = Nothing
            Dim WorkflowOutArguments As IDictionary(Of String, Object) = Nothing
            Dim isNullResult As Boolean = True
            Dim isFoundData As Boolean = False
            
            Try
                InMotionGIT.FASI.Support.Authentication.AuthorizationProcess("*")
                UProfileParametersInstance = RetrieveFormInformationFromSession(instance.InstanceFormId)
                UserInfo = New InMotionGIT.Membership.Providers.MemberContext
                formContext = New InMotionGIT.Common.Contracts.Context(InMotionGIT.FASI.Support.Handlers.LanguageHandler.LanguageId(), 
                                                                       instance.InstanceFormId) With {.UserId = HttpContext.Current.Session("UserId"), 
                                                                                                      .UserCode = HttpContext.Current.Session("nUsercode"), 
                                                                                                      .SecuritySchemeCode = HttpContext.Current.Session("sSche_code"), 
                                                                                                      .AccessToken = HttpContext.Current.Session("AccessToken")}
                currentAction = SessionTrace("btnSaClick")
                UProfileParametersInstance = EntryDataToClass(UProfileParametersInstance, instance)
                currentAction = SessionTrace("1. UProfileParametersInstance.FrontOfficeMembershipUser.Country = UProfileParametersInstance.countryAuxiliar...")
                currentAction = SessionTrace("1.1. UProfileParametersInstance.FrontOfficeMembershipUser.Country = UProfileParametersInstance.countryAuxiliar...")
                                If IsNothing(UProfileParametersInstance.FrontOfficeMembershipUser) Then
                    UProfileParametersInstance.FrontOfficeMembershipUser = New InMotionGIT.Membership.Providers.FrontOfficeMembershipUser
                End If

                UProfileParametersInstance.FrontOfficeMembershipUser.Country = UProfileParametersInstance.countryAuxiliar

currentAction = SessionTrace("2. Call 'Save user' library")
                Dim _Boolean_4f95136419d847d4a2f3e61b28240652 As System.Boolean 
                _Boolean_4f95136419d847d4a2f3e61b28240652 = InMotionGIT.Membership.Providers.Helper.SaveChange(userName:=UProfileParametersInstance.userNameTemporal, userChanged:=UProfileParametersInstance.FrontOfficeMembershipUser, languageId:=UProfileParametersInstance.FrontOfficeMembershipUser.LanguageID, theme:=UProfileParametersInstance.FrontOfficeMembershipUser.Theme) 
 
            UProfileParametersInstance.stateSave = _Boolean_4f95136419d847d4a2f3e61b28240652 

                currentAction = SessionTrace("3. If UProfileParametersInstance.stateSave = True Then")
                If UProfileParametersInstance.stateSave = True Then

                    currentAction = SessionTrace("4. Url: '/fasi/default.aspx?resetUser=true'")
                        
                With resultData
                    .AddRedirect(String.Format(CultureInfo.InvariantCulture,"/fasi/default.aspx?resetUser=true&culture={0}",UProfileParametersInstance.FrontOfficeMembershipUser.LanguageID))
                End With
                    Else
                    currentAction = SessionTrace("5. The message 'Could not save chang...' will displayed as 'Popup'")
                    ParametersToDictionary(UProfileParametersInstance, parametersDictionary)
                    messageAction = InMotionGIT.FASI.Support.utils.JSONResources.LocalResource(HttpContext.Current.Server.MapPath(""), "UProfile", HttpContext.Current.Request.Headers("Accept-Language"), "app.form.btnSa_Message_5", "Por favor espere...")
                    messageAction = InMotionGIT.FrontOffice.Proxy.Helpers.Email.Process(messageAction, parametersDictionary)
                    resultData.AddNotifyPopup(messageAction)
                        End If

                instance = ClassToEntryData(instance, UProfileParametersInstance)
                StoreFormInformationOnSession(UProfileParametersInstance)
                
                With resultData
                    .Success = True
                    .Data = New With {.Instance = instance, .LookUps = Nothing}
                End With

            Catch ex As Exception
                resultData = InMotionGIT.FrontOffice.Support.ExceptionHandler.ProcessServerAction(ex, "UProfile", "btnSaClick", currentAction)
            End Try
            
            Return resultData
        End Function

#End Region

#Region "Lookups Web Methods"


        <WebMethod(EnableSession:=True)>
        Public Shared Function LookUpForCountry(id As String) As InMotionGIT.FrontOffice.Support.DataType.ClientActionResult
            
            Dim result As New InMotionGIT.FrontOffice.Support.DataType.ClientActionResult With {.Success = True}
            Dim resultData As DataTable = Nothing
            Dim newLookupList As New List(Of InMotionGIT.Common.DataType.LookUpValue)                       
            
            Try
                InMotionGIT.FASI.Support.Authentication.AuthorizationProcess("*")
                Dim UProfileParametersInstance As UProfileParameters = RetrieveFormInformationFromSession(id) 
                
                With New DataManagerFactory(String.Format(CultureInfo.CurrentCulture,
                                                          "SELECT  TABLE66.NCOUNTRY, TABLE66.SDESCRIPT FROM TABLE66 TABLE66    WHERE NOT TABLE66.SDESCRIPT IS NULL ORDER BY SDESCRIPT", ""), 
                                            "TABLE66", "Linked.LatCombined")

                    .Cache = InMotionGIT.Common.Enumerations.EnumCache.CacheWithFullParameters
                    resultData = .QueryExecuteToTable(True)
                End With

                If Not IsNothing(resultData) Then
                    For Each item As DataRow In resultData.Rows
                        newLookupList.Add(New InMotionGIT.Common.DataType.LookUpValue With {.Code = item.NumericValue("NCOUNTRY"),
                                                                                            .Description = item.StringValue("SDESCRIPT")})
                    Next
                End If

                result.Data = newLookupList

            Catch ex As Exception
                result = InMotionGIT.FrontOffice.Support.ExceptionHandler.ProcessClientAction(ex, "UProfile", "LookUpForCountry", String.Empty)
            End Try
                        
            Return result
        End Function


#End Region

#Region "Form Actions"

        Private Shared Sub Form_Initialization(ByRef currentAction As String, ByRef UProfileParametersInstance As UProfileParameters, ByRef resultData As InMotionGIT.FrontOffice.Support.DataType.ServerActionResult)
            Dim UserInfo As New InMotionGIT.Membership.Providers.MemberContext
            
            Dim formContext As New InMotionGIT.Common.Contracts.Context(InMotionGIT.FASI.Support.Handlers.LanguageHandler.LanguageId(), 
                                                                        UProfileParametersInstance.InternalId) With {.UserId = HttpContext.Current.Session("UserId"), 
                                                                                                                     .UserCode = HttpContext.Current.Session("nUsercode"), 
                                                                                                                     .SecuritySchemeCode = HttpContext.Current.Session("sSche_code"), 
                                                                                                                     .AccessToken = HttpContext.Current.Session("AccessToken")}
            Dim selectDataTableItem As DataTable = Nothing
            Dim parametersDictionary As Dictionary(Of String, Object) = Nothing
            Dim WorkflowInArguments As Dictionary(Of String, Object) = Nothing
            Dim WorkflowOutArguments As IDictionary(Of String, Object) = Nothing
            Dim messageAction As String = String.Empty
            Dim isNullResult As Boolean = True
            Dim isFoundData As Boolean = False

            currentAction = SessionTrace("Form_Initialization")

currentAction = SessionTrace("1. Call 'Retrieve User Context' library")
                Dim _FrontOfficeMembershipUser_8bb0082a52a84930b167b1198e68937a As InMotionGIT.Membership.Providers.FrontOfficeMembershipUser 
                _FrontOfficeMembershipUser_8bb0082a52a84930b167b1198e68937a = InMotionGIT.Membership.Providers.Helper.RetriveUserContext(forcedLoading:=true) 
 
                isNullResult = (IsNothing(_FrontOfficeMembershipUser_8bb0082a52a84930b167b1198e68937a)) 
                If Not isNullResult Then
                    UProfileParametersInstance.FrontOfficeMembershipUser = _FrontOfficeMembershipUser_8bb0082a52a84930b167b1198e68937a
                End If

            currentAction = SessionTrace("2. UProfileParametersInstance.countryAuxiliar = UProfileParametersInstance.FrontOfficeMembershipUser...")
            currentAction = SessionTrace("2.1. UProfileParametersInstance.countryAuxiliar = UProfileParametersInstance.FrontOfficeMembershipUser...")

            UProfileParametersInstance.countryAuxiliar = UProfileParametersInstance.FrontOfficeMembershipUser.Country

            currentAction = SessionTrace("3. UProfileParametersInstance.userNameTemporal = UProfileParametersInstance.FrontOfficeMembershipUser...")
            currentAction = SessionTrace("3.1. UProfileParametersInstance.userNameTemporal = UProfileParametersInstance.FrontOfficeMembershipUser...")

            UProfileParametersInstance.userNameTemporal = UProfileParametersInstance.FrontOfficeMembershipUser.UserName

            currentAction = SessionTrace("4. UProfileParametersInstance.languageIdAuxiliar = UProfileParametersInstance.FrontOfficeMembershipUser...")
            currentAction = SessionTrace("4.1. UProfileParametersInstance.languageIdAuxiliar = UProfileParametersInstance.FrontOfficeMembershipUser...")

            UProfileParametersInstance.languageIdAuxiliar = UProfileParametersInstance.FrontOfficeMembershipUser.LanguageID

            currentAction = SessionTrace("5. UProfileParametersInstance.passwordQuestion = UProfileParametersInstance.FrontOfficeMembershipUser...")
            currentAction = SessionTrace("5.1. UProfileParametersInstance.passwordQuestion = UProfileParametersInstance.FrontOfficeMembershipUser...")

            UProfileParametersInstance.passwordQuestion = UProfileParametersInstance.FrontOfficeMembershipUser.PasswordQuestion

            currentAction = SessionTrace("6. UProfileParametersInstance.userEmailTemporal = UProfileParametersInstance.FrontOfficeMembershipUser...")
            currentAction = SessionTrace("6.1. UProfileParametersInstance.userEmailTemporal = UProfileParametersInstance.FrontOfficeMembershipUser...")

            UProfileParametersInstance.userEmailTemporal = UProfileParametersInstance.FrontOfficeMembershipUser.Email

currentAction = SessionTrace("7. Call 'Traza de acceso' library")
                Dim _UserSecurityTraceCollection_5b860894c7cf4905a80fc3f888502c37 As InMotionGIT.Membership.Providers.Contracts.UserSecurityTraceCollection 
                _UserSecurityTraceCollection_5b860894c7cf4905a80fc3f888502c37 = InMotionGIT.Membership.Providers.Helper.UserSecurityTraceRetriveByEmail(email:=UProfileParametersInstance.userEmailTemporal, languageId:=UProfileParametersInstance.FrontOfficeMembershipUser.LanguageID) 
 
                isNullResult = (IsNothing(_UserSecurityTraceCollection_5b860894c7cf4905a80fc3f888502c37)) 
                If Not isNullResult Then
                    UProfileParametersInstance.UserSecurityTraceCollection = _UserSecurityTraceCollection_5b860894c7cf4905a80fc3f888502c37
                End If

            currentAction = SessionTrace("8. zonego.Visible = False")
            currentAction = SessionTrace("8.1. zonego.Visible = False...")
            resultData.AddControlBehavior("zonego", "hide")


            
        End Sub

#End Region
#Region "Utilities"

        Private Shared Sub ParametersToDictionary(formData As UProfileParameters, ByRef target As Dictionary(Of String, Object))
            If IsNothing(target) Then
                target = New Dictionary(Of String, Object)

                target.Add("Key", formData.Key)
                target.Add("stateValidator", formData.stateValidator)
                target.Add("stateIsLocal", formData.stateIsLocal)
                target.Add("FrontOfficeMembershipUser", formData.FrontOfficeMembershipUser)
                target.Add("stateSave", formData.stateSave)
                target.Add("userNameTemporal", formData.userNameTemporal)
                target.Add("userEmailTemporal", formData.userEmailTemporal)
                target.Add("UserSecurityTraceCollection", formData.UserSecurityTraceCollection)
                target.Add("countryAuxiliar", formData.countryAuxiliar)
                target.Add("languageIdAuxiliar", formData.languageIdAuxiliar)
                target.Add("IsChangeQuestionAndAnswerSecret", formData.IsChangeQuestionAndAnswerSecret)
                target.Add("passwordQuestion", formData.passwordQuestion)
            Else
                target("Key") = formData.Key
                target("stateValidator") = formData.stateValidator
                target("stateIsLocal") = formData.stateIsLocal
                target("FrontOfficeMembershipUser") = formData.FrontOfficeMembershipUser
                target("stateSave") = formData.stateSave
                target("userNameTemporal") = formData.userNameTemporal
                target("userEmailTemporal") = formData.userEmailTemporal
                target("UserSecurityTraceCollection") = formData.UserSecurityTraceCollection
                target("countryAuxiliar") = formData.countryAuxiliar
                target("languageIdAuxiliar") = formData.languageIdAuxiliar
                target("IsChangeQuestionAndAnswerSecret") = formData.IsChangeQuestionAndAnswerSecret
                target("passwordQuestion") = formData.passwordQuestion
            End If
        End Sub

        Private Shared Function SessionTrace(message As String) As String

            If Not IsNothing(HttpContext.Current.Session("Form.Track")) AndAlso HttpContext.Current.Session("Form.Track").ToString.ToLower = "true" Then
                Dim tracelog As String = HttpContext.Current.Session(String.Format(CultureInfo.InvariantCulture, "Form.{0}.trace", IO.Path.GetFileNameWithoutExtension("Page.AppRelativeVirtualPath")))

                tracelog += String.Format(CultureInfo.InvariantCulture, "{0} {1}<br>{2}", Now.ToString("hh:mm:ss.fff"), message, vbCrLf)
                HttpContext.Current.Session(String.Format(CultureInfo.InvariantCulture, "Form.{0}.trace", IO.Path.GetFileNameWithoutExtension("Page.AppRelativeVirtualPath"))) = tracelog
            End If

            Return message
        End Function

#End Region
#Region "Storage Session Methods"

        Private Shared Function RetrieveFormInformationFromSession(id As String) As UProfileParameters
            
            Dim source As String = HttpContext.Current.Session(String.Format(CultureInfo.InvariantCulture, "Form.Storage.{0}", id))
            Dim instance As UProfileParameters = Nothing

            If Not String.IsNullOrEmpty(source) Then
                instance = Serialize.Deserialize(Of UProfileParameters)(source)
            End If
            
            Return instance
        End Function

        Private Shared Sub StoreFormInformationOnSession(instance As UProfileParameters)
            
            If Not IsNothing(instance) Then
                HttpContext.Current.Session(String.Format(CultureInfo.InvariantCulture, "Form.Storage.{0}", instance.InternalId)) = Serialize.Serialize(Of UProfileParameters)(instance)
                HttpContext.Current.Session(String.Format(CultureInfo.InvariantCulture, "Form.Title.{0}", instance.InternalId)) = "Información del perfil"
              
                If Not IsNothing(HttpContext.Current.Session("Form.Track")) AndAlso
                   HttpContext.Current.Session("Form.Track").ToString.ToLower = "true" Then

                    HttpContext.Current.Session(String.Format(CultureInfo.InvariantCulture, "Form.UProfile", instance.InternalId)) = instance
                End If

                If Not IsNothing(HttpContext.Current.Session("Form.Track.Parameters")) AndAlso
                   HttpContext.Current.Session("Form.Track.Parameters").ToString.ToLower = "true" Then

                    If Not IsNothing(HttpContext.Current.Session("Form.Track")) AndAlso HttpContext.Current.Session("Form.Track").ToString.ToLower = "true" Then
                        InMotionGIT.Common.Helpers.FileHandler.SaveContent(String.Format(CultureInfo.InvariantCulture, "{0}\{1}.UProfile.txt",
                                                                                         ConfigurationManager.AppSettings("Path.Logs"), instance.InternalId),
                                                                                          HttpContext.Current.Session(String.Format(CultureInfo.InvariantCulture,
                                                                                                                     "Form.{0}.trace", IO.Path.GetFileNameWithoutExtension("Page.AppRelativeVirtualPath"))))
                    End If

                    InMotionGIT.Common.Helpers.Serialize.SerializeToFile(Of UProfileParameters)(instance,
                                                                                                String.Format(CultureInfo.InvariantCulture,
                                                                                                              "{0}\{1}.UProfile.xml", ConfigurationManager.AppSettings("Path.Logs"), instance.InternalId), True)
                End If			
            End If
            
        End Sub

#End Region


#Region "Contracts Mappers"

        Private Shared Function EntryDataToClass(parametersData As UProfileParameters, formData As EntryData) As UProfileParameters
            If IsNothing(parametersData) Then
                parametersData = New UProfileParameters
            End If

            If IsNothing(parametersData.FrontOfficeMembershipUser) Then
                parametersData.FrontOfficeMembershipUser = New InMotionGIT.Membership.Providers.FrontOfficeMembershipUser
            End If
            If IsNothing(parametersData.UserSecurityTraceCollection) Then
                parametersData.UserSecurityTraceCollection = New InMotionGIT.Membership.Providers.Contracts.UserSecurityTraceCollection
            End If

            With parametersData
                .InternalId = formData.InstanceFormId
                .userNameTemporal = formData.userNameTemporal
                .userEmailTemporal = formData.userEmailTemporal
                .FrontOfficeMembershipUser.FirstName = formData.FrontOfficeMembershipUserFirstName
                .FrontOfficeMembershipUser.SurName = formData.FrontOfficeMembershipUserSurName
                .FrontOfficeMembershipUser.LastName = formData.FrontOfficeMembershipUserLastName
                .FrontOfficeMembershipUser.SecondLastName = formData.FrontOfficeMembershipUserSecondLastName
                .FrontOfficeMembershipUser.DateofBirth = formData.FrontOfficeMembershipUserDateofBirth
                .FrontOfficeMembershipUser.Gender = formData.FrontOfficeMembershipUserGender
                .FrontOfficeMembershipUser.AddressHome = formData.FrontOfficeMembershipUserAddressHome
                .countryAuxiliar = formData.countryAuxiliar
                .FrontOfficeMembershipUser.City = formData.FrontOfficeMembershipUserCity
                .FrontOfficeMembershipUser.State = formData.FrontOfficeMembershipUserState
                .FrontOfficeMembershipUser.TelephoneNumber = formData.FrontOfficeMembershipUserTelephoneNumber
                .FrontOfficeMembershipUser.LanguageID = formData.FrontOfficeMembershipUserLanguageID

            End With

            Return parametersData
        End Function

        Private Shared Function ClassToEntryData(formData As EntryData, parametersData As UProfileParameters) As EntryData
            formData = New EntryData

            With formData
                .InstanceFormId = parametersData.InternalId
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserUserName = parametersData.FrontOfficeMembershipUser.UserName
                End If
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserEmail = parametersData.FrontOfficeMembershipUser.Email
                End If
                .userNameTemporal = parametersData.userNameTemporal
                .userEmailTemporal = parametersData.userEmailTemporal
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserFirstName = parametersData.FrontOfficeMembershipUser.FirstName
                End If
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserSurName = parametersData.FrontOfficeMembershipUser.SurName
                End If
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserLastName = parametersData.FrontOfficeMembershipUser.LastName
                End If
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserSecondLastName = parametersData.FrontOfficeMembershipUser.SecondLastName
                End If
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserDateofBirth = parametersData.FrontOfficeMembershipUser.DateofBirth
                End If
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserGender = parametersData.FrontOfficeMembershipUser.Gender
                End If
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserAddressHome = parametersData.FrontOfficeMembershipUser.AddressHome
                End If
                .countryAuxiliar = parametersData.countryAuxiliar
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserCity = parametersData.FrontOfficeMembershipUser.City
                End If
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserState = parametersData.FrontOfficeMembershipUser.State
                End If
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserTelephoneNumber = parametersData.FrontOfficeMembershipUser.TelephoneNumber
                End If
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserLanguageID = parametersData.FrontOfficeMembershipUser.LanguageID
                End If
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserLastLoginDate = parametersData.FrontOfficeMembershipUser.LastLoginDate
                End If
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserLastActivityDate = parametersData.FrontOfficeMembershipUser.LastActivityDate
                End If
                If Not IsNothing(parametersData.FrontOfficeMembershipUser) Then
                    .FrontOfficeMembershipUserLastLockoutDate = parametersData.FrontOfficeMembershipUser.LastLockoutDate
                End If
                .UserSecurityTrace_UserSecurityTrace = New List(Of UserSecurityTrace_UserSecurityTraceItem)

                If Not IsNothing(parametersData.UserSecurityTraceCollection) Then
                    Dim newItem As UserSecurityTrace_UserSecurityTraceItem
                    
                    For Each itemData As InMotionGIT.Membership.Providers.Contracts.UserSecurityTrace In parametersData.UserSecurityTraceCollection
                        newItem = New UserSecurityTrace_UserSecurityTraceItem
                        
                        With newItem
                            .EffectDate = itemData.EffectDate
                            .Host = itemData.Host
                            .State = itemData.State
                            .Result = itemData.Result
                            .ID = itemData.ID                        
                        End With

                        .UserSecurityTrace_UserSecurityTrace.Add(newItem)
                    Next

                    If .UserSecurityTrace_UserSecurityTrace.Count <> 0 Then

                    End If
                End If


            End With

            Return formData
        End Function

#End Region

#Region "Common Utilities"

        Private Shared Sub ValidateParametersInstance(ByRef formData As UProfileParameters)
            If IsNothing(formData.FrontOfficeMembershipUser) Then
                formData.FrontOfficeMembershipUser = New InMotionGIT.Membership.Providers.FrontOfficeMembershipUser
            End If
            If IsNothing(formData.UserSecurityTraceCollection) Then
                formData.UserSecurityTraceCollection = New InMotionGIT.Membership.Providers.Contracts.UserSecurityTraceCollection
            End If

        End Sub

#End Region

#Region "Form Contracts"

        <Serializable()>
        <DataContract()>
        Public Class EntryData

            <DataMember()> Public Property InstanceFormId As String
            <DataMember()> Public Property FrontOfficeMembershipUserUserName As System.String
            <DataMember()> Public Property FrontOfficeMembershipUserEmail As System.String
            <DataMember()> Public Property userNameTemporal As String
            <DataMember()> Public Property userEmailTemporal As String
            <DataMember()> Public Property FrontOfficeMembershipUserFirstName As System.String
            <DataMember()> Public Property FrontOfficeMembershipUserSurName As System.String
            <DataMember()> Public Property FrontOfficeMembershipUserLastName As System.String
            <DataMember()> Public Property FrontOfficeMembershipUserSecondLastName As System.String
            <DataMember()> Public Property FrontOfficeMembershipUserDateofBirth As System.DateTime
            <DataMember()> Public Property FrontOfficeMembershipUserGender As System.String
            <DataMember()> Public Property FrontOfficeMembershipUserAddressHome As System.String
            <DataMember()> Public Property countryAuxiliar As Int32
            <DataMember()> Public Property FrontOfficeMembershipUserCity As System.String
            <DataMember()> Public Property FrontOfficeMembershipUserState As System.String
            <DataMember()> Public Property FrontOfficeMembershipUserTelephoneNumber As System.Int32
            <DataMember()> Public Property FrontOfficeMembershipUserLanguageID As System.Int32
            <DataMember()> Public Property FrontOfficeMembershipUserLastLoginDate As System.DateTime
            <DataMember()> Public Property FrontOfficeMembershipUserLastActivityDate As System.DateTime
            <DataMember()> Public Property FrontOfficeMembershipUserLastLockoutDate As System.DateTime
            <DataMember()> Public Property UserSecurityTraceCollectionEffectDate As System.DateTime
            <DataMember()> Public Property UserSecurityTraceCollectionHost As System.String
            <DataMember()> Public Property UserSecurityTraceCollectionState As System.String
            <DataMember()> Public Property UserSecurityTraceCollectionResult As System.String
            <DataMember()> Public Property UserSecurityTraceCollectionID As System.Int32
            <DataMember()> Public Property UserSecurityTrace_UserSecurityTrace As List(Of UserSecurityTrace_UserSecurityTraceItem)

        End Class

        <Serializable()>
        <DataContract()>
        Public Class UserSecurityTrace_UserSecurityTraceItem

            <DataMember()> Public Property EffectDate As System.DateTime
            <DataMember()> Public Property Host As System.String
            <DataMember()> Public Property State As System.String
            <DataMember()> Public Property Result As System.String
            <DataMember()> Public Property ID As System.Int32

        End Class

        <Serializable()>
        Public Class UProfileParameters
            Inherits InMotionGIT.FrontOffice.Support.DataType.FormBase(Of UProfileParameters)

            Public Property Key As String
            Public Property stateValidator As Boolean
            Public Property stateIsLocal As Boolean
            Public Property FrontOfficeMembershipUser As InMotionGIT.Membership.Providers.FrontOfficeMembershipUser
            Public Property stateSave As Boolean
            Public Property userNameTemporal As String
            Public Property userEmailTemporal As String
            Public Property UserSecurityTraceCollection As InMotionGIT.Membership.Providers.Contracts.UserSecurityTraceCollection
            Public Property countryAuxiliar As Int32
            Public Property languageIdAuxiliar As String
            Public Property IsChangeQuestionAndAnswerSecret As Boolean
            Public Property passwordQuestion As String

        End Class
#End Region

    End Class

End Namespace

