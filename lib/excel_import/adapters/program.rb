module ExcelImport
	module Adapters
		class Program < DataShift::Excel
			# HEADERS = [:loan_purpose, :loan_size, :loan_type, :team, :interest_rate, :lock_period, :fannie_mae, :base_rate, :adjustment_rate]
		  HEADERS = [:base_rate, :adjustment_rate, :loan_size, :loan_type, :term, :fannie_mae]

		  attr_accessor :headers, :start_index, :reached_end

		  def initialize
		    super
		    @headers = HEADERS
		  end

		  def sheet_final
		    @current_sheet = self.worksheets.first
		    ret = []
		    ret << get_single_row
		    ret
		  end

		  def get_single_row
		    extractor = ExcelImport::Extractors::Program.new @current_sheet
		    base_rate = extractor.base_rate.to_json
		    adjustment_rate = extractor.adjustment_rate.to_json
		    loan_size = extractor.loan_size
		    loan_type = extractor.loan_type
		    term = extractor.term
		    fannie_mae = true

		    return [base_rate, adjustment_rate, loan_size, loan_type, term, fannie_mae]
		  end
		end
	end
end
