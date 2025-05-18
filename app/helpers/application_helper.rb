module ApplicationHelper
   # 検索ワード部分を強調するメソッド
   def highlight(text, query)
    return text unless query.present?

    query = Regexp.escape(query) # 正規表現で検索するためエスケープ
    text.gsub(Regexp.new("(?=#{query})"), "<mark>").gsub(Regexp.new("(?<=#{query})"), "</mark>").html_safe
  end
end
