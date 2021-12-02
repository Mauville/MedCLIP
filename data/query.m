let
    Source = Csv.Document(File.Contents("C:\Users\X220\Desktop\ImageCrawler\trimmed.csv"),[Delimiter=",", Columns=10, Encoding=1252, QuoteStyle=QuoteStyle.Csv]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Column1", type text}, {"Column2", type text}, {"Column3", type text}, {"Column4", type text}, {"Column5", type text}, {"Column6", type text}, {"Column7", type text}, {"Column8", type text}, {"Column9", type text}, {"Column10", type text}}),
    #"Promoted Headers" = Table.PromoteHeaders(#"Changed Type", [PromoteAllScalars=true]),
    #"Changed Type1" = Table.TransformColumnTypes(#"Promoted Headers",{{"Diagnosis", type text}, {"Caption", type text}, {"Core_Modality", type text}, {"Full_Modality", type text}, {"Case_Diagnosis", type text}, {"Diagnosis_By", type text}, {"Location", type text}, {"Category", type text}, {"Keywords", type text}, {"filename", type text}}),
    #"Merged Queries" = Table.NestedJoin(#"Changed Type1", {"filename"}, cleansed, {"filename"}, "cleansed", JoinKind.LeftOuter),
    #"Expanded cleansed" = Table.ExpandTableColumn(#"Merged Queries", "cleansed", {"Demographics", "Plane"}, {"Demographics", "Plane"}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Expanded cleansed", "Demographics", Splitter.SplitTextByEachDelimiter({"."}, QuoteStyle.Csv, true), {"Demographics.1", "Demographics.2"}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Demographics.1", type text}, {"Demographics.2", type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type2",{{"Demographics.1", "Patient_Age"}, {"Demographics.2", "Patient_Gender"}}),
    #"Replaced Value" = Table.ReplaceValue(#"Renamed Columns"," y.o","",Replacer.ReplaceText,{"Patient_Age"}),
    #"Changed Type3" = Table.TransformColumnTypes(#"Replaced Value",{{"Patient_Age", Int64.Type}})
in
    #"Changed Type3"
