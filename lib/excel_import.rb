module ExcelImport
	Dir[File.dirname(__FILE__) + "/excel_import/*.rb"].each {|file| require file }
	Dir[File.dirname(__FILE__) + "/excel_import/adapters/*.rb"].each {|file| require file }
	Dir[File.dirname(__FILE__) + "/excel_import/extractors/*.rb"].each {|file| require file }
end
