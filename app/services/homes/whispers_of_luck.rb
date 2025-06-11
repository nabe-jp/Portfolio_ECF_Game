module Homes
  # ホームズ用の乱数生成メソッド
  class WhispersOfLuck
    def initialize(max_luck_count)
      @max_luck_count = max_luck_count                # 処理を行う回数
      @count = 0                                      # 現在の処理の回数
      if @max_luck_count >= 2
        @used_values = Array.new(max_luck_count - 2)  # 使用された値を格納、0から始まり最後の1回は記載しない-2
      end
    end
  
    def generate_lucky_numbers
      lucky_numbers = []  # lucky_numbersに変更
  
      while @count < @max_luck_count
        drawn_number = rand(1..53)  # num -> drawn_number
  
        # 同じ結果は数字は使わない、処理回数が1回なら使用した数字を記録しない
        if @max_luck_count != 1 && @used_values.include?(drawn_number) == false
          lucky_numbers << drawn_number
          @used_values << drawn_number
          @count += 1
        elsif @max_luck_count == 1
          lucky_numbers << drawn_number
          @count += 1
        else
          # 使った結果が4回以上の場合、再度ランダムで選び直し
          next
        end
      end
      lucky_numbers  # 配列を返す
    end
  end
end