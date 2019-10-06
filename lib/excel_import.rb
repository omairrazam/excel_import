module ExcelImport
	Dir["excel_import/*.rb"].each {|file| require file }
	Dir["excel_import/adapters/*.rb"].each {|file| require file }
	Dir["excel_import/extractors/*.rb"].each {|file| require file }
end
