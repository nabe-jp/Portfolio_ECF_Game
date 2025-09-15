module Public::GroupEventsHelper
  # グループ内イベントの日時のセレクトボックス、標準だと月のセレクトボックスのみ単位が入るため以下を作成

  # 選択できる年は現在と＋2年に設定、分は5刻み
  def datetime_select_with_units(form, field, start_year: Time.current.year, 
      end_year: Time.current.year + 2, minute_step: 5)
      
    now = Time.current

    # 日付部分: 年・月・日
    # 横幅60%、md以下では横幅100%で縦並び(group-events-editor__datetime-dateで設定)
    content_tag :div, class: "form-inline flex-wrap" do
      date_selects = content_tag :div, class: "group-events-editor__datetime-date" do
        # (1i)=>年, (2i)=>月, (3i)=>日
        form.select("#{field}(1i)", (start_year..end_year).map { |y| ["#{y}年", y] },
          { selected: now.year }, class: "form-control") +
        form.select("#{field}(2i)", (1..12).map { |m| ["#{m}月", m] },
          { selected: now.month }, class: "form-control") +
        form.select("#{field}(3i)", (1..31).map { |d| ["#{d}日", d] },
          { selected: now.day }, class: "form-control")
      end

      # 時間部分: 時・分
      # 残り幅を自動で割り当て、md以下では横幅100%で縦並び(group-events-editor__datetime-timeで設定)
      time_selects = content_tag :div, class: "group-events-editor__datetime-time" do
        # (4i)=>時, (5i)=>分
        form.select("#{field}(4i)", (0..23).map { |h| ["#{h}時", h] },
          { selected: now.hour }, class: "form-control") +
        form.select("#{field}(5i)", (0..59).step(minute_step).map { |m| ["#{m}分", m] },
          { selected: now.min - now.min % minute_step }, class: "form-control")
      end

      # 日付部分 + 時間部分 をまとめて返す
      date_selects + time_selects
    end
  end
end