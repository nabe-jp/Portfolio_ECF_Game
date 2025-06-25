module Homes
  # ホームズ用の乱数生成メソッド
  class WhispersOfLuck
    def initialize(max_luck_count)
      @max_luck_count = max_luck_count                # 処理を行う回数
      @count = 0                                      # 現在の処理の回数
      if @max_luck_count >= 2
        @used_values = Array.new(max_luck_count - 2)  # max_luck_countが2以上の際、使用した配列を記録する
      end
    end
  
    def generate_lucky_numbers
      lucky_numbers = []                              # 生成された乱数を格納する配列
  
      while @count < @max_luck_count
        drawn_number = rand(1..53)                    # num -> drawn_number
  
        # 同じ数字は使用しない(重複回避)、ただし1回のみ生成する場合は記録せずそのまま使用
        if @max_luck_count != 1 && @used_values.include?(drawn_number) == false
          lucky_numbers << drawn_number
          @used_values << drawn_number
          @count += 1
        elsif @max_luck_count == 1
          lucky_numbers << drawn_number
          @count += 1
        else
          # 処理を行う回数(@max_luck_count)に達していない場合、再度ランダムで選び直し
          next
        end
      end
      lucky_numbers  # 配列を返す
    end
  end
end