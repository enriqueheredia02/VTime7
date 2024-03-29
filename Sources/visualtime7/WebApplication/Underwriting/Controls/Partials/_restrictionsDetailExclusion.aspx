﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="_restrictionsDetailExclusion.aspx.vb" Inherits="Underwriting_Controls_Partials_restrictionsDetail_Exclusion" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><% Response.Write(GetLocalResourceObject("title"))%></title>
</head>
<body>
    <form id="form-restrictions-detail-exclusion" name="form-restrictions-detail-exclusion" action="" class="form-horizontal">
         <div class="col-md-6" id="divTipo">
            <div class="form-group">
                <label for="txtTipo" class="col-sm-4 control-label">
                    <% Response.Write(GetLocalResourceObject("txtTipo"))%>:</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="txtTipo" name="txtTipo"
                        readonly="readonly" title="<% Response.Write(GetLocalResourceObject("txtTipoToolTip"))%>" />
                </div>
            </div>
        </div>

        <div class="col-md-6" id="divAseguradoExcluir">
            <div class="form-group">
                <label for="txtAseguradoExcluir" class="col-sm-4 control-label">
                    <% Response.Write(GetLocalResourceObject("txtAseguradoExcluir"))%>:</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="txtAseguradoExcluir" name="txtTarifa"
                        readonly="readonly" title="<% Response.Write(GetLocalResourceObject("txtAseguradoExcluirToolTip"))%>" />
                </div>
            </div>
        </div>

        <div class="col-md-6" id="divModulo">
            <div class="form-group">
                <label for="txtModulo" class="col-sm-4 control-label">
                    <% Response.Write(GetLocalResourceObject("txtModulo"))%>:</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="txtModulo" name="txtModulo"
                        readonly="readonly" title="<% Response.Write(GetLocalResourceObject("txtModuloToolTip"))%>" />    
                </div>
            </div>
        </div>

        <div class="col-md-6" id="divCobertura">
            <div class="form-group">
                <label for="txtCobertura" class="col-sm-4 control-label">
                    <% Response.Write(GetLocalResourceObject("txtCobertura"))%>:</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="txtCobertura" name="txtCobertura"
                        readonly="readonly" title="<% Response.Write(GetLocalResourceObject("txtCoberturaToolTip"))%>" /> 
                </div>
            </div>
        </div>


        <div class="col-md-6" id="divEnfermedad">
            <div class="form-group">
                <label for="txtEnfermedad" class="col-sm-4 control-label">
                    <% Response.Write(GetLocalResourceObject("txtEnfermedad"))%>:</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="txtEnfermedad" name="txtEnfermedad"
                        readonly="readonly" title="<% Response.Write(GetLocalResourceObject("txtEnfermedadToolTip"))%>" />
                </div>
            </div>
        </div>        

        <div class="col-md-6" id="divCausa">
            <div class="form-group">
                <label for="txtDias" class="col-sm-4 control-label">
                    <% Response.Write(GetLocalResourceObject("txtCausa"))%>:</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="txtCausa" name="txtCausa"
                        readonly="readonly" title="<% Response.Write(GetLocalResourceObject("txtCausaToolTip"))%>" />              

                </div>
            </div>
        </div>

        <div class="col-md-6" id="divPeriodo">
            <div class="form-group">
                <label for="txtPeriodo" class="col-sm-4 control-label">
                    <% Response.Write(GetLocalResourceObject("txtPeriodo"))%>:</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="txtPeriodo" name="txtPeriodo"
                        readonly="readonly" title="<% Response.Write(GetLocalResourceObject("txtPeriodoToolTip"))%>" />     
                </div>
            </div>
        </div>

        <div class="col-md-6" id="divDias">
            <div class="form-group">
                <label for="txtDias" class="col-sm-4 control-label">
                    <% Response.Write(GetLocalResourceObject("txtDias"))%>:</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="txtDias" name="txtDias"
                        readonly="readonly" title="<% Response.Write(GetLocalResourceObject("txtDiasToolTip"))%>" />              

                </div>
            </div>
        </div>

        <div class="col-md-6" id="divMeses">
            <div class="form-group">
                <label for="txtMeses" class="col-sm-4 control-label">
                    <% Response.Write(GetLocalResourceObject("txtMeses"))%>:</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="txtMeses" name="txtMeses"
                        readonly="readonly" title="<% Response.Write(GetLocalResourceObject("txtMesesToolTip"))%>" />     
                </div>
            </div>
        </div>

        <div class="col-md-6" id="divYear">
            <div class="form-group">
                <label for="txtYear" class="col-sm-4 control-label">
                    <% Response.Write(GetLocalResourceObject("txtYear"))%>:</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="txtYear" name="txtYear"
                        readonly="readonly" title="<% Response.Write(GetLocalResourceObject("txtYearToolTip"))%>" />   

                </div>
            </div>
        </div>

        <div class="col-md-6" id="divTarifa">
            <div class="form-group">
                <label for="txtTarifa" class="col-sm-4 control-label">
                    <% Response.Write(GetLocalResourceObject("txtTarifa"))%>:</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="txtTarifa" name="txtTarifa"
                        readonly="readonly" title="<% Response.Write(GetLocalResourceObject("txtTarifaToolTip"))%>" />
                </div>
            </div>
        </div>

    </form> 
    <link href="../Styles/fasi.css?v=<%=System.IO.File.GetLastWriteTime(Server.MapPath("~") + "\Styles\fasi.css").ToString("yyyyMMddHHmmss")%>" rel="stylesheet" />
    <script type="text/javascript" src="scripts/_informacionGeneral.js?v=<%=System.IO.File.GetLastWriteTime(Server.MapPath("~") + "\Underwriting\scripts\_informacionGeneral.js").ToString("yyyyMMddHHmmss")%>"></script>
</body>
</html>
