﻿Option Explicit On
Public Class Fund_distributions
    Implements System.Collections.IEnumerable

    'variable local para contener colección
    Private mCol As Collection
    '% Find: Devuelve información de los registros de la tabla Fund_distribution
    Public Function Find(ByVal nBranch As Integer, ByVal nProduct As Integer, ByVal nTypeProfile As Double, ByVal dEffecdate As Date) As Boolean

        Dim lrecReaFund_distribution As eRemoteDB.Execute
        Dim lclsFund_distribution As Fund_distribution

        On Error GoTo Find_Err

        lrecReaFund_distribution = New eRemoteDB.Execute

        '+ Definición de parámetros para stored procedure 'insudb.reaFund_distribution'

        With lrecReaFund_distribution
            .StoredProcedure = "INSMVI70PKG.REAFUND_DISTRIBUTION_KEY"
            .Parameters.Add("nBranch", nBranch, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbInteger, 22, 0, 10, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
            .Parameters.Add("nProduct", nProduct, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbInteger, 22, 0, 10, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
            .Parameters.Add("nTypeProfile", nTypeProfile, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbDouble, 22, 0, 10, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)
            .Parameters.Add("dEffecdate", dEffecdate, eRemoteDB.Parameter.eRmtDataDir.rdbParamInput, eRemoteDB.Parameter.eRmtDataType.rdbDBTimeStamp, 0, 0, 0, eRemoteDB.Parameter.eRmtDataAttrib.rdbParamNullable)

            If .Run Then
                Find = True
                Do While Not .EOF
                    lclsFund_distribution = New Fund_distribution

                    lclsFund_distribution.nBranch = nBranch
                    lclsFund_distribution.nProduct = nProduct
                    lclsFund_distribution.nTypeprofile = nTypeProfile
                    lclsFund_distribution.dEffecdate = .FieldToClass("dEffecdate")
                    lclsFund_distribution.nFunds = .FieldToClass("nFunds")
                    lclsFund_distribution.nOrigin = .FieldToClass("nOrigin")
                    lclsFund_distribution.nPercent = .FieldToClass("nPercent")

                    Call Add(lclsFund_distribution)
                    .RNext()
                    'UPGRADE_NOTE: Object lclsFund_distribution may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
                    lclsFund_distribution = Nothing
                Loop
                .RCloseRec()
            End If
        End With

        Find = True

Find_Err:
        If Err.Number Then
            Find = False
        End If
        On Error GoTo 0

        'UPGRADE_NOTE: Object lrecReaFund_distribution may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        lrecReaFund_distribution = Nothing

    End Function

  '%Add:
    Public Function Add(ByRef objClass As Fund_distribution) As Fund_distribution
        If objClass Is Nothing Then
            objClass = New Fund_distribution
        End If

        With objClass
            mCol.Add(objClass, "DB" & .nBranch & .nProduct & .nTypeprofile & .nFunds & .nOrigin & .dEffecdate.ToString("yyyyMMdd"))

        End With

        'return the object created
        Add = objClass
    End Function

    Public ReadOnly Property Item(ByVal vntIndexKey As Object) As Fund_distribution
        Get
            'se usa al hacer referencia a un elemento de la colección
            'vntIndexKey contiene el índice o la clave de la colección,
            'por lo que se declara como un Variant
            'Syntax: Set foo = x.Item(xyz) or Set foo = x.Item(5)
            Item = mCol.Item(vntIndexKey)
        End Get
    End Property

    Public ReadOnly Property Count() As Integer
        Get
            'se usa al obtener el número de elementos de la
            'colección. Sintaxis: Debug.Print x.Count
            Count = mCol.Count()
        End Get
    End Property


    'UPGRADE_NOTE: NewEnum property was commented out. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="B3FC1610-34F3-43F5-86B7-16C984F0E88E"'
    'Public ReadOnly Property NewEnum() As stdole.IUnknown
        'Get
            'esta propiedad permite enumerar
            'esta colección con la sintaxis For...Each
            'NewEnum = mCol._NewEnum
        'End Get
    'End Property

    Public Function GetEnumerator() As System.Collections.IEnumerator Implements System.Collections.IEnumerable.GetEnumerator
        'UPGRADE_TODO: Uncomment and change the following line to return the collection enumerator. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="95F9AAD0-1319-4921-95F0-B9D3C4FF7F1C"'
        GetEnumerator = mCol.GetEnumerator
    End Function


    Public Sub Remove(ByRef vntIndexKey As Object)
        'se usa al quitar un elemento de la colección
        'vntIndexKey contiene el índice o la clave, por lo que se
        'declara como un Variant
        'Sintaxis: x.Remove(xyz)

        mCol.Remove(vntIndexKey)
    End Sub


    'UPGRADE_NOTE: Class_Initialize was upgraded to Class_Initialize_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
    Private Sub Class_Initialize_Renamed()
        'crea la colección cuando se crea la clase
        mCol = New Collection
    End Sub
    Public Sub New()
        MyBase.New()
        Class_Initialize_Renamed()
    End Sub


    'UPGRADE_NOTE: Class_Terminate was upgraded to Class_Terminate_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
    Private Sub Class_Terminate_Renamed()
        'destruye la colección cuando se termina la clase
        'UPGRADE_NOTE: Object mCol may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        mCol = Nothing
    End Sub
    Protected Overrides Sub Finalize()
        Class_Terminate_Renamed()
        MyBase.Finalize()
    End Sub
End Class
