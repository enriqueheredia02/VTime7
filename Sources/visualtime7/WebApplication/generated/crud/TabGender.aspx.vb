﻿#Region "using"

Imports System.Globalization
Imports GIT.Core
Imports DevExpress.Web.ASPxGridView
Imports DevExpress.Web.ASPxEditors
Imports System
Imports DevExpress.Web.Data
Imports InMotionGIT.Common.Proxy
Imports InMotionGIT.Common.Proxy.Helpers.Language
Imports InMotionGIT.Common.Helpers
Imports InMotionGIT.Data
Imports System.IO
Imports DevExpress.Web.ASPxClasses
Imports System.Data
Imports System.Data.Common
Imports DevExpress.Web.ASPxUploadControl

#End Region

Partial Class Maintenance_TabGender
    Inherits PageBase

#Region "Private fields"

    Private _internalCall As Boolean

#End Region

#Region "Events Page"

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsCallback AndAlso Not IsPostBack Then
            Dim newItem As DevExpress.Web.ASPxMenu.MenuItem

            For Each languageItem As KeyValuePair(Of Integer, String) In LanguageToDictionary(LanguageId)

                newItem = New DevExpress.Web.ASPxMenu.MenuItem

                With newItem
                    .Name = String.Format(CultureInfo.InvariantCulture, "{0}Item", languageItem.Value)
                    .Text = languageItem.Value
                    .Image.Url = String.Format(CultureInfo.InvariantCulture, "/images/16x16/Flags/{0}.png", languageItem.Key)
                    .Index = languageItem.Key
                     
                    If languageItem.Key = LanguageId Then
                        MainMenu.Items(4).Text = String.Format(CultureInfo.InvariantCulture, "{0} {1}", GetLocalResourceObject("LanguageItemMenu").ToString(), languageItem.Value)
                        MainMenu.Items(4).Image.Url = String.Format(CultureInfo.InvariantCulture, "/images/16x16/Flags/{0}.png", languageItem.Key)

                        .Visible = False
                    Else
                        .Visible = True
                    End If
                End With

                MainMenu.Items(4).Items.Add(newItem)
            Next 

        End If
        
        If Not CurrentState.Contains("LanguageId") Then
            CurrentState.Add("LanguageId", LanguageId)
        End If
    End Sub

#End Region

#Region "MainMenu Events"

    Protected Sub MainMenu_ItemClick(source As Object, e As DevExpress.Web.ASPxMenu.MenuItemEventArgs) Handles MainMenu.ItemClick
        If String.Equals(e.Item.Parent.Name, "LanguageItem", StringComparison.CurrentCultureIgnoreCase) Then
            e.Item.Parent.Text = String.Format(CultureInfo.InvariantCulture, "{0} {1}", GetLocalResourceObject("LanguageItemMenu").ToString(), e.Item.Text)
            e.Item.Parent.Image.Url = String.Format(CultureInfo.InvariantCulture, "/images/16x16/Flags/{0}.png", e.Item.Index)

            e.Item.Visible = False

            For Each item As DevExpress.Web.ASPxMenu.MenuItem In e.Item.Parent.Items
                If Not String.Equals(item.Text, e.Item.Text, StringComparison.CurrentCultureIgnoreCase) Then
                    item.Visible = True
                End If
            Next

            CurrentState.Set("LanguageId", DescriptionToEnumLanguage(e.Item.Text, LanguageId))
            _internalCall = True

            TabGender_Grid.DataBind()
        End If      
    End Sub

#End Region

#Region "Controls Events"

         
    
 

#End Region

#Region "TabGender_Grid Events"
    
    Protected Sub TabGender_Grid_CustomColumnDisplayText(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewColumnDisplayTextEventArgs) Handles TabGender_Grid.CustomColumnDisplayText
          Dim data As DataTable
          Dim rows() As DataRow
           
          Select Case e.Column.FieldName

               Case Else              
           End Select
    End Sub
  
    Protected Sub TabGender_Grid_DataBinding(ByVal sender As Object, ByVal e As EventArgs) Handles TabGender_Grid.DataBinding
        If (Not IsNothing(Request.Params("__CALLBACKID")) AndAlso Request.Params("__CALLBACKID").EndsWith("TabGender_Grid")) Or _internalCall Then
                       If Caching.Exist("EnumRecordStatus") Then
                DirectCast(TabGender_Grid.Columns("RECORDSTATUS"), GridViewDataComboBoxColumn).PropertiesComboBox.DataSource = Caching.GetItem("EnumRecordStatus")

            Else
                Dim source As DataTable = Nothing

                With New DataManagerFactory("SELECT  ENUMRECORDSTATUS.RECORDSTATUS, ENUMRECORDSTATUS.RECORDSTATUSCODE, ETRANRECORDSTATUS.LANGUAGEID, ETRANRECORDSTATUS.DESCRIPTION FROM COMMON.ENUMRECORDSTATUS ENUMRECORDSTATUS JOIN ETRANRECORDSTATUS ETRANRECORDSTATUS ON ETRANRECORDSTATUS.RECORDSTATUS = ENUMRECORDSTATUS.RECORDSTATUS  WHERE ENUMRECORDSTATUS.RECORDSTATUSCODE = '1' AND ETRANRECORDSTATUS.LANGUAGEID = @:LANGUAGEID  ORDER BY ETranRecordStatus.Description ASC", "EnumRecordStatus", "Linked.Common")
                    .AddParameter("LANGUAGEID", DbType.Decimal, 5, False, CurrentState.Get("LanguageId"))
 
                    source = .QueryExecuteToTable(True)
                    DirectCast(TabGender_Grid.Columns("RECORDSTATUS"), GridViewDataComboBoxColumn).PropertiesComboBox.DataSource = source
                End With

                If Not IsNothing(source) AndAlso source.Rows.Count > 0 Then
                    Caching.SetItem("EnumRecordStatus", source)
                End If
            End If 
 

                 With New DataManagerFactory("SELECT  TABGENDER.GENDER, TABGENDER.RECORDSTATUS, TRANSGENDER.GENDER, TRANSGENDER.LANGUAGEID, TRANSGENDER.DESCRIPTION, TRANSGENDER.SHORTDESCRIPTION FROM UNDERWRITING.TABGENDER TABGENDER JOIN TRANSGENDER TRANSGENDER ON TRANSGENDER.GENDER = TABGENDER.GENDER  WHERE TRANSGENDER.LANGUAGEID = @:LANGUAGEID ORDER BY TabGender.Gender ASC", "TabGender", "Linked.Underwriting")                 
                                                   
                      .AddParameter("LANGUAGEID", DbType.Decimal, 5, False, CurrentState.Get("LanguageId"))
            
                      TabGender_Grid.DataSource = .QueryExecuteToTable(True)
                 End With 
        End If     
    End Sub

    Protected Sub TabGender_Grid_CellEditorInitialize(sender As Object, e As ASPxGridViewEditorEventArgs) Handles TabGender_Grid.CellEditorInitialize
        If TabGender_Grid.IsNewRowEditing Then
            Select Case e.Column.FieldName
                
                
                
                Case "GENDER"                     
                       e.Editor.Focus()               
            End Select

        Else

            Select Case e.Column.FieldName
                Case "GENDER"
     e.Editor.Enabled = False
                   
                
                
                Case "RECORDSTATUS"                     
                     e.Editor.Focus()
            End Select
        End If
        
       Select Case e.Column.FieldName
           Case "GENDER"
                 
                 
           Case "RECORDSTATUS"
     DirectCast(e.Editor, ASPxComboBox).DataBindItems() 

        End Select
    End Sub

    Protected Sub TabGender_Grid_RowInserting(ByVal sender As Object, ByVal e As ASPxDataInsertingEventArgs) Handles TabGender_Grid.RowInserting 
        Dim isNullResult As Boolean = True
        
             With New DataManagerFactory("INSERT INTO UNDERWRITING.TabGender (GENDER, RECORDSTATUS, CREATORUSERCODE, CREATIONDATE, UPDATEUSERCODE, UPDATEDATE) VALUES (@:GENDER, @:RECORDSTATUS, @:CREATORUSERCODE, SYSDATE, @:UPDATEUSERCODE, SYSDATE)", "TabGender", "Linked.Underwriting")                 
                                                   
                       .AddParameter("GENDER", DbType.Decimal, 0, False, e.NewValues("GENDER"))
.AddParameter("RECORDSTATUS", DbType.Decimal, 0, False, e.NewValues("RECORDSTATUS"))
.AddParameter("CREATORUSERCODE", DbType.Decimal, 0, False, Session("nUserCode"))
.AddParameter("UPDATEUSERCODE", DbType.Decimal, 0, False, Session("nUserCode"))
            
                       .CommandExecute()
                End With
            For Each languageItem As KeyValuePair(Of Integer, String) In LanguageToDictionary(LanguageId)
                     With New DataManagerFactory("INSERT INTO TransGender (GENDER, LANGUAGEID, DESCRIPTION, SHORTDESCRIPTION, CREATORUSERCODE, CREATIONDATE, UPDATEUSERCODE, UPDATEDATE) VALUES (@:GENDER, @:LANGUAGEID, @:DESCRIPTION, @:SHORTDESCRIPTION, @:CREATORUSERCODE, SYSDATE, @:UPDATEUSERCODE, SYSDATE)", "TransGender", "Linked.Underwriting")                 
                                                   
                       .AddParameter("GENDER", DbType.Decimal, 0, False, e.NewValues("GENDER"))
.AddParameter("LANGUAGEID", DbType.Decimal, 0, False, languageItem.Key)
.AddParameter("DESCRIPTION", DbType.AnsiString, 0, False, e.NewValues("DESCRIPTION"))
.AddParameter("SHORTDESCRIPTION", DbType.AnsiString, 0, False, e.NewValues("SHORTDESCRIPTION"))
.AddParameter("CREATORUSERCODE", DbType.Decimal, 0, False, Session("nUserCode"))
.AddParameter("UPDATEUSERCODE", DbType.Decimal, 0, False, Session("nUserCode"))
            
                       .CommandExecute()
                End With
           Next

               
        e.Cancel = True
        TabGender_Grid.CancelEdit()
    End Sub

    Protected Sub TabGender_Grid_RowUpdating(ByVal sender As Object, ByVal e As ASPxDataUpdatingEventArgs) Handles TabGender_Grid.RowUpdating
        Dim isNullResult As Boolean = True
          
             With New DataManagerFactory("UPDATE UNDERWRITING.TabGender SET RECORDSTATUS = @:RECORDSTATUS, UPDATEUSERCODE = @:UPDATEUSERCODE WHERE GENDER = @:GENDER", "TabGender", "Linked.Underwriting")                 
                                                   
                       .AddParameter("RECORDSTATUS", DbType.Decimal, 0, False, e.NewValues("RECORDSTATUS"))
.AddParameter("UPDATEUSERCODE", DbType.Decimal, 0, False, Session("nUserCode"))
.AddParameter("GENDER", DbType.Decimal, 0, False, e.Keys("GENDER"))
            
                       .CommandExecute()
                End With
     With New DataManagerFactory("UPDATE TransGender SET DESCRIPTION = @:DESCRIPTION, SHORTDESCRIPTION = @:SHORTDESCRIPTION, UPDATEUSERCODE = @:UPDATEUSERCODE WHERE GENDER = @:GENDER AND LANGUAGEID = @:LANGUAGEID", "TransGender", "Linked.Underwriting")                 
                                                   
                       .AddParameter("DESCRIPTION", DbType.AnsiString, 0, False, e.NewValues("DESCRIPTION"))
.AddParameter("SHORTDESCRIPTION", DbType.AnsiString, 0, False, e.NewValues("SHORTDESCRIPTION"))
.AddParameter("UPDATEUSERCODE", DbType.Decimal, 0, False, Session("nUserCode"))
.AddParameter("GENDER", DbType.Decimal, 0, False, e.Keys("GENDER"))
.AddParameter("LANGUAGEID", DbType.Decimal, 0, False, CurrentState.Get("LanguageId"))
            
                       .CommandExecute()
                End With         
      
         e.Cancel = True
        TabGender_Grid.CancelEdit()
    End Sub
    
    Protected Sub TabGender_Grid_CustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs) Handles TabGender_Grid.CustomCallback     
           Dim isNullResult As Boolean = True
           
           Select Case e.Parameters.ToString.ToLower
               Case "delete"
                       Dim GENDERKey As Generic.List(Of Object) = TabGender_Grid.GetSelectedFieldValues("GENDER")
        
               For index As Integer = 0 To GENDERKey.Count - 1
                  With New DataManagerFactory("DELETE FROM TransGender WHERE GENDER = @:GENDER ", "TransGender", "Linked.Underwriting")                 
                                                   
               .AddParameter("GENDER", DbType.Decimal, 0, False, GENDERKey(index))
            
               .CommandExecute()
          End With 
 With New DataManagerFactory("DELETE FROM UNDERWRITING.TabGender WHERE GENDER = @:GENDER ", "TabGender", "Linked.Underwriting")                 
                                                   
               .AddParameter("GENDER", DbType.Decimal, 0, False, GENDERKey(index))
            
               .CommandExecute()
          End With 
                       
              Next           
           
              TabGender_Grid.DataBind()
                 
               Case Else
                   Dim fileName As String = String.Empty
                
                   If e.Parameters.ToString.ToLower.StartsWith("export") Then
                       Dim extension As String = e.Parameters.ToString.ToLower.Split("_")(1)
                       fileName = String.Format(CultureInfo.InvariantCulture, "{0}.{1}", IO.Path.GetRandomFileName, extension)

                       ASPxGridViewExporter.GridViewID = sender.ClientInstanceName

                       Using fs As FileStream = New FileStream(String.Format(CultureInfo.InvariantCulture, "{0}\generated\{1}", Server.MapPath("/"), fileName), FileMode.Create)
                           Select Case extension
                               Case "pdf"
                                   ASPxGridViewExporter.WritePdf(fs)
                               Case "xls"
                                   ASPxGridViewExporter.WriteXls(fs)
                               Case "xlsx"
                                   ASPxGridViewExporter.WriteXlsx(fs)
                               Case "rtf"
                                   ASPxGridViewExporter.WriteRtf(fs)
                               Case Else
                           End Select
                      End Using

                      ASPxWebControl.RedirectOnCallback(String.Format(CultureInfo.InvariantCulture, "~/dropthings/download.ashx?Directory=generated&File={0}", fileName))
                               
                  End If
         End Select
     End Sub
    
    Protected Sub TabGender_Grid_RowValidating(sender As Object, e As ASPxDataValidationEventArgs) Handles TabGender_Grid.RowValidating
        Dim errorMessage As String = "<ol style='font-weight:lighter'>"
        
        If IsNothing(e.NewValues("GENDER")) OrElse e.NewValues("GENDER") = 0  
   e.Errors(TabGender_Grid.Columns("GENDER")) = GetLocalResourceObject("GENDERMessageErrorRequired1Resource").ToString
End If
 
        
        If e.IsNewRow Then
           Dim rowCountKey As System.Int32
  With New DataManagerFactory("SELECT  TABGENDER.GENDER ROWCOUNT FROM UNDERWRITING.TABGENDER TABGENDER  WHERE TABGENDER.GENDER = @:GENDER", "TabGender", "Linked.Underwriting")
             .AddParameter("GENDER", DbType.Decimal, 5, False, e.NewValues("GENDER"))
 
             rowCountKey = .QueryExecuteScalarToInteger()  
        End With
        If rowCountKey > 0 Then
                errorMessage += String.Format(CultureInfo.InvariantCulture, "</ol><ul style='font-weight:bold'>{0}</ul>", 
                                                                            GetLocalResourceObject("TabGender_GridMessageErrorGeneralValidator0Resource").ToString)                
                e.RowError = errorMessage
        End If


           
        Else        
            If e.Errors.Count > 0 Then          
                For Each item As KeyValuePair(Of GridViewColumn, String) In e.Errors
                    errorMessage += String.Format("<li>{0}</li>", item.Value)
                Next

                errorMessage += String.Format(CultureInfo.InvariantCulture, "</ol><ul style='font-weight:bold'>{0}</ul>", 
                                                                            GetLocalResourceObject("MessageErrorText").ToString)
                e.RowError = errorMessage
            End If
        End If
    End Sub

#End Region
 
#Region "TransGender_Grid Events"
    
    Protected Sub TransGender_Grid_CustomColumnDisplayText(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewColumnDisplayTextEventArgs) Handles TransGender_Grid.CustomColumnDisplayText
          Dim data As DataTable
          Dim rows() As DataRow
           
          Select Case e.Column.FieldName

               Case Else              
           End Select
    End Sub
  
    Protected Sub TransGender_Grid_DataBinding(ByVal sender As Object, ByVal e As EventArgs) Handles TransGender_Grid.DataBinding
        If (Not IsNothing(Request.Params("__CALLBACKID")) AndAlso Request.Params("__CALLBACKID").EndsWith("TransGender_Grid")) Or _internalCall Then
                       If Caching.Exist("EnumRecordStatus") Then
                DirectCast(TransGender_Grid.Columns("RECORDSTATUS"), GridViewDataComboBoxColumn).PropertiesComboBox.DataSource = Caching.GetItem("EnumRecordStatus")

            Else
                Dim source As DataTable = Nothing

                With New DataManagerFactory("SELECT  ENUMRECORDSTATUS.RECORDSTATUS, ENUMRECORDSTATUS.RECORDSTATUSCODE, ETRANRECORDSTATUS.LANGUAGEID, ETRANRECORDSTATUS.DESCRIPTION FROM COMMON.ENUMRECORDSTATUS ENUMRECORDSTATUS JOIN ETRANRECORDSTATUS ETRANRECORDSTATUS ON ETRANRECORDSTATUS.RECORDSTATUS = ENUMRECORDSTATUS.RECORDSTATUS  WHERE ENUMRECORDSTATUS.RECORDSTATUSCODE = '1' AND ETRANRECORDSTATUS.LANGUAGEID = @:LANGUAGEID  ORDER BY ETranRecordStatus.Description ASC", "EnumRecordStatus", "Linked.Common")
                    .AddParameter("LANGUAGEID", DbType.Decimal, 5, False, CurrentState.Get("LanguageId"))
 
                    source = .QueryExecuteToTable(True)
                    DirectCast(TransGender_Grid.Columns("RECORDSTATUS"), GridViewDataComboBoxColumn).PropertiesComboBox.DataSource = source
                End With

                If Not IsNothing(source) AndAlso source.Rows.Count > 0 Then
                    Caching.SetItem("EnumRecordStatus", source)
                End If
            End If 
             If Caching.Exist("TabLanguage") Then
                DirectCast(TransGender_Grid.Columns("LANGUAGEID"), GridViewDataComboBoxColumn).PropertiesComboBox.DataSource = Caching.GetItem("TabLanguage")

            Else
                Dim source As DataTable = Nothing

                With New DataManagerFactory("SELECT  TABLANGUAGE.LANGUAGEID, TABLANGUAGE.RECORDSTATUS, TRANSLANGUAGE.LANGUAGEID, TRANSLANGUAGE.DESCRIPTION FROM COMMON.TABLANGUAGE TABLANGUAGE JOIN TRANSLANGUAGE TRANSLANGUAGE ON TRANSLANGUAGE.LANGUAGECODEID = TABLANGUAGE.LANGUAGEID  WHERE TABLANGUAGE.RECORDSTATUS = '1' AND TRANSLANGUAGE.LANGUAGEID = @:LANGUAGEID  ORDER BY TransLanguage.Description ASC", "TabLanguage", "Linked.Common")
                    .AddParameter("LANGUAGEID", DbType.Decimal, 5, False, CurrentState.Get("LanguageId"))
 
                    source = .QueryExecuteToTable(True)
                    DirectCast(TransGender_Grid.Columns("LANGUAGEID"), GridViewDataComboBoxColumn).PropertiesComboBox.DataSource = source
                End With

                If Not IsNothing(source) AndAlso source.Rows.Count > 0 Then
                    Caching.SetItem("TabLanguage", source)
                End If
            End If 
 

                 With New DataManagerFactory("SELECT  TABGENDER.GENDER, TABGENDER.RECORDSTATUS, TRANSGENDER.GENDER, TRANSGENDER.LANGUAGEID, TRANSGENDER.DESCRIPTION, TRANSGENDER.SHORTDESCRIPTION FROM UNDERWRITING.TABGENDER TABGENDER JOIN TRANSGENDER TRANSGENDER ON TRANSGENDER.GENDER = TABGENDER.GENDER   ORDER BY TabGender.Gender ASC", "TabGender", "Linked.Underwriting")                 
                                                   
                                  
                      TransGender_Grid.DataSource = .QueryExecuteToTable(True)
                 End With 
        End If     
    End Sub

    Protected Sub TransGender_Grid_CellEditorInitialize(sender As Object, e As ASPxGridViewEditorEventArgs) Handles TransGender_Grid.CellEditorInitialize
        If TransGender_Grid.IsNewRowEditing Then
            Select Case e.Column.FieldName
                
                
                
                Case "GENDER"                     
                       e.Editor.Focus()               
            End Select

        Else

            Select Case e.Column.FieldName
                Case "GENDER"
     e.Editor.Enabled = False
Case "LANGUAGEID"
     e.Editor.Enabled = False
                   
                
                
                Case "RECORDSTATUS"                     
                     e.Editor.Focus()
            End Select
        End If
        
       Select Case e.Column.FieldName
           Case "GENDER"
                 
                 
           Case "RECORDSTATUS"
     DirectCast(e.Editor, ASPxComboBox).DataBindItems() 
Case "LANGUAGEID"
     DirectCast(e.Editor, ASPxComboBox).DataBindItems() 

        End Select
    End Sub

    Protected Sub TransGender_Grid_RowInserting(ByVal sender As Object, ByVal e As ASPxDataInsertingEventArgs) Handles TransGender_Grid.RowInserting 
        Dim isNullResult As Boolean = True
        
        
               
        e.Cancel = True
        TransGender_Grid.CancelEdit()
    End Sub

    Protected Sub TransGender_Grid_RowUpdating(ByVal sender As Object, ByVal e As ASPxDataUpdatingEventArgs) Handles TransGender_Grid.RowUpdating
        Dim isNullResult As Boolean = True
          
             With New DataManagerFactory("UPDATE TransGender SET DESCRIPTION = @:DESCRIPTION, SHORTDESCRIPTION = @:SHORTDESCRIPTION, UPDATEUSERCODE = @:UPDATEUSERCODE WHERE GENDER = @:GENDER AND LANGUAGEID = @:LANGUAGEID", "TransGender", "Linked.Underwriting")                 
                                                   
                       .AddParameter("DESCRIPTION", DbType.AnsiString, 0, False, e.NewValues("DESCRIPTION"))
.AddParameter("SHORTDESCRIPTION", DbType.AnsiString, 0, False, e.NewValues("SHORTDESCRIPTION"))
.AddParameter("UPDATEUSERCODE", DbType.Decimal, 0, False, Session("nUserCode"))
.AddParameter("GENDER", DbType.Decimal, 0, False, e.Keys("GENDER"))
.AddParameter("LANGUAGEID", DbType.Decimal, 0, False, e.Keys("LANGUAGEID"))
            
                       .CommandExecute()
                End With         
      
         e.Cancel = True
        TransGender_Grid.CancelEdit()
    End Sub
    
    Protected Sub TransGender_Grid_CustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs) Handles TransGender_Grid.CustomCallback     
           Dim isNullResult As Boolean = True
           
           Select Case e.Parameters.ToString.ToLower
               Case "delete"
                   
                 
               Case Else
                   Dim fileName As String = String.Empty
                
                   If e.Parameters.ToString.ToLower.StartsWith("export") Then
                       Dim extension As String = e.Parameters.ToString.ToLower.Split("_")(1)
                       fileName = String.Format(CultureInfo.InvariantCulture, "{0}.{1}", IO.Path.GetRandomFileName, extension)

                       ASPxGridViewExporter.GridViewID = sender.ClientInstanceName

                       Using fs As FileStream = New FileStream(String.Format(CultureInfo.InvariantCulture, "{0}\generated\{1}", Server.MapPath("/"), fileName), FileMode.Create)
                           Select Case extension
                               Case "pdf"
                                   ASPxGridViewExporter.WritePdf(fs)
                               Case "xls"
                                   ASPxGridViewExporter.WriteXls(fs)
                               Case "xlsx"
                                   ASPxGridViewExporter.WriteXlsx(fs)
                               Case "rtf"
                                   ASPxGridViewExporter.WriteRtf(fs)
                               Case Else
                           End Select
                      End Using

                      ASPxWebControl.RedirectOnCallback(String.Format(CultureInfo.InvariantCulture, "~/dropthings/download.ashx?Directory=generated&File={0}", fileName))
                               
                  End If
         End Select
     End Sub
    
    Protected Sub TransGender_Grid_RowValidating(sender As Object, e As ASPxDataValidationEventArgs) Handles TransGender_Grid.RowValidating
        Dim errorMessage As String = "<ol style='font-weight:lighter'>"
        
        If IsNothing(e.NewValues("GENDER")) OrElse e.NewValues("GENDER") = 0  
   e.Errors(TransGender_Grid.Columns("GENDER")) = GetLocalResourceObject("GENDERMessageErrorRequired1Resource").ToString
End If
 
        
        If e.IsNewRow Then
           Dim rowCountKey As System.Int32
  With New DataManagerFactory("SELECT  TRANSGENDER.GENDER ROWCOUNT, TRANSGENDER.LANGUAGEID FROM TRANSGENDER TRANSGENDER  WHERE TRANSGENDER.GENDER = @:GENDER AND TRANSGENDER.LANGUAGEID = @:LANGUAGEID", "TransGender", "Linked.Underwriting")
             .AddParameter("GENDER", DbType.Decimal, 5, False, e.NewValues("GENDER"))
.AddParameter("LANGUAGEID", DbType.Decimal, 5, False, e.NewValues("LANGUAGEID"))
 
             rowCountKey = .QueryExecuteScalarToInteger()  
        End With
        If rowCountKey > 0 Then
                errorMessage += String.Format(CultureInfo.InvariantCulture, "</ol><ul style='font-weight:bold'>{0}</ul>", 
                                                                            GetLocalResourceObject("TransGender_GridMessageErrorGeneralValidator0Resource").ToString)                
                e.RowError = errorMessage
        End If


           
        Else        
            If e.Errors.Count > 0 Then          
                For Each item As KeyValuePair(Of GridViewColumn, String) In e.Errors
                    errorMessage += String.Format("<li>{0}</li>", item.Value)
                Next

                errorMessage += String.Format(CultureInfo.InvariantCulture, "</ol><ul style='font-weight:bold'>{0}</ul>", 
                                                                            GetLocalResourceObject("MessageErrorText").ToString)
                e.RowError = errorMessage
            End If
        End If
    End Sub

#End Region
 


End Class