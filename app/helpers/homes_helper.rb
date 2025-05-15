module HomesHelper
  # ホームズ用の乱数生成メソッド
  class WhispersOfLuck
    def initialize(max_luck_count)
      @max_luck_count = max_luck_count  # MAX_DISPLAY_COUNTはmax_luck_countに変更
      @count = 0                        # 現在のカウント
      @used_values = Hash.new(0)        # 使用された値のカウント
      @luck_whispers = 0                # j -> luck_whispers（運命のささやき）
    end
  
    def generate_lucky_numbers
      lucky_numbers = []  # lucky_numbersに変更
  
      while @count < @max_luck_count
        drawn_number = rand(1..53)  # num -> drawn_number
  
        if drawn_number == 53
          # 53が出た場合、幸運のささやきのカウントを1増やし、再度ランダム選択
          @luck_whispers += 1
          next if @luck_whispers < 2
          lucky_numbers << 14  # 14は「選ばれし番号」
          @count += 1
        else
          # 53以外が出た場合、4で割ってその結果を使う
          lucky_value = drawn_number / 4  # result -> lucky_value
          remainder = drawn_number % 4   # remainder -> remainder (変更なし)
          
          if remainder != 0
            # あまりが出た場合、幸運のささやきを1増やして再度ランダム選択
            @luck_whispers += 1
            next if @luck_whispers < 2
          end
  
          # 同じ結果は4回まで使える
          if @used_values[lucky_value] < 4
            lucky_numbers << lucky_value
            @used_values[lucky_value] += 1
            @count += 1
          else
            # 使った結果が4回以上の場合、再度ランダムで選び直し
            next
          end
        end
      end
      lucky_numbers  # 配列を返す
    end
  end
end