module Public::GroupPostsHelper
  # グループ投稿の公開ステータスを表示するバッジ
  # "公開ステータス："は色なし、"公開中"と"非公開"は色付き

  def group_post_status_badge(group_post)
    if group_post.visible_to_non_members
      # divタグ内にテキストとspanタグを連結
      content_tag :div, class: "group-post-show__post-status" do
        concat "公開ステータス：" 
        concat content_tag(:span, "公開中", class: "group-post-show__post-status--public")
      end
      # 上記コードで以下のように表示される
      # <div class="group-post-show__post-status">
      #   公開ステータス：<span class="group-post-show__post-status--public">公開中</span>
      # </div>
      
    else
      content_tag :div, class: "group-post-show__post-status" do
        concat "公開ステータス："
        concat content_tag(:span, "非公開", class: "group-post-show__post-status--private")
      end
    end
  end
end