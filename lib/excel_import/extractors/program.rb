module ExcelImport
  module Extractors
    class Program
      attr_accessor :base_rate, :adjustment_rate, :loan_size, :loan_type, :term, :current_sheet
      delegate :row, to: :current_sheet

      def initialize sheet
        @current_sheet = sheet
        load_data
      end

      def load_data
        get_base_rate
        get_adjustment_rate
        get_loan_size
        get_loan_type
        get_term
      end

      def get_base_rate
        start_row = 8
        start_col = 2
        end_row = 33

        base_rate = {}
        @current_sheet.each_with_index do |row, index|
          next if index < start_row
          break if index > end_row
          base_value = row[start_col]

          day_values = {
              '15': row[start_col + 1],
              '30': row[start_col + 2],
              '45': row[start_col + 3],
              '60': row[start_col + 4]
          }.with_indifferent_access

          base_rate[base_value.to_s] = day_values
        end

        @base_rate = base_rate.with_indifferent_access

      end

      def get_adjustment_rate
        start_row = 122
        start_col = 6
        end_row = 129

        adjustment_rate = {}
        @current_sheet.each_with_index do |row, index|
          next if index < start_row
          break if index > end_row

          base_value = row[start_col]

          values = {
              '< 620': row[start_col + 3],
              '620 - 639': row[start_col + 4],
              '640 - 659': row[start_col + 5],
              '660 - 679': row[start_col + 6],
              '680 - 699': row[start_col + 7],
              '700 - 719': row[start_col + 8],
              '720 - 739': row[start_col + 9],
              '740 - 759': row[start_col + 10],
              '≥ 760': row[start_col + 11]

          }.with_indifferent_access

          adjustment_rate[base_value.to_s] = values
        end

        @adjustment_rate = adjustment_rate.with_indifferent_access

      end

      def get_loan_size
        string = row(122)[2]
        @loan_size = %w(Non-Conforming Conforming Jumbo).find {|matcher| /#{matcher}/i =~ string}
      end

      def get_loan_type
        string = row(122)[2]
        @loan_type = %w(Fixed ARM).find {|matcher| /#{matcher}/i =~ string}
      end

      def get_term
        string = row(122)[2]
        @term = string.scan(/\d+?yrs/).pop()
      end
    end
  end
end

