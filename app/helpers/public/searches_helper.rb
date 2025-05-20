module Public::SearchesHelper
  def number_of_items_displayed(items)
    if items.total_count <= 1
      "（該当する件数は#{items.total_count}件です）"
    else
      from = (items.current_page - 1) * items.limit_value + 1
      to = [from + items.limit_value - 1, items.total_count].min      # .minで小さい方を取得
    
      if from == to
        "（全#{items.total_count}件中 #{from}件目を表示）"
      else
        "（全#{items.total_count}件中　#{from} ~ #{to}件を表示）"
      end
    end
  end
end