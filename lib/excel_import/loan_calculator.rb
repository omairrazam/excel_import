module ExcelImport
  class LoanCalculator 
    def initialize(loan_amount,ltv_percentage,fisco_st_cr,product_type,lck_period,intrest_rate, program)
      @loan_amount    = loan_amount
      @ltv_percentage = ltv_percentage
      @fisco_st_cr    = fisco_st_cr
      @product_type   = product_type
      @lck_period     = lck_period
      @intrest_rate   = intrest_rate
      @program        = program
    end

    def get_base_point
      base_rate =  JSON.parse(@program.base_rate)
      point = base_rate[@intrest_rate.to_s][@lck_period.to_s]
      get_decimal point
    end

    def get_adjustments_point
      adj_rate =  JSON.parse(@program.adjustment_rate)
      point = adj_rate
       .find{|key,value| /#{@ltv_percentage}/i =~ key}
       .pop
       .find{|k,v|/#{@fisco_st_cr}/i =~ k}
       .pop

       point
    end

    def get_decimal num
      dec = num.to_s.split('.')
      return "0.#{dec}".to_f
    end

    def calculate
      net = get_base_point -  get_adjustments_point
      final  = net * net
    end

    def process
      @base_point = get_base_point
      @adjustment_point = get_adjustments_point.to_s
      calculate
    end 
  end
end





