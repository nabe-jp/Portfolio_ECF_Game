# link フォルダ

このフォルダには、リンク専用の部分テンプレートがadmin側とpublic側に分けてあります。
deviseで使用するリンク専用の部分テンプレートはadmin側とpublic側のshared/authにあります。

呼び出し方:  文字列の場合
            <% render "~/links", 変数名: true%>

            例
            <%= render "shared/link/public/links", home: true %>

            ボタンの場合
            <% render "~/links", 変数名: true, as: :button %>

            例
            <%= render "shared/link/public/links", home: true, as: :botton %>