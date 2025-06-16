module Admin::Publishable
  extend ActiveSupport::Concern

  included do
    before_action :set_resource_for_publication, only: [:hide, :publish]
  end

  def hide
    if @resource.update(is_public: false)
      redirect_to after_publication_path, notice: "#{resource_name}を非公開にしました。"
    else
      redirect_to after_publication_path, alert: "非公開に失敗しました。"
    end
  end

  def publish
    if @resource.update(is_public: true)
      redirect_to after_publication_path, notice: "#{resource_name}を公開しました。"
    else
      redirect_to after_publication_path, alert: "公開に失敗しました。"
    end
  end

  private

  # この中のメソッドを使用する際に使用、各コントローラでオーバーライドする(しなかった場合エラーを出す)
  def set_resource_for_publication
    raise NotImplementedError, "set_resource_for_publicationメソッドを、コントローラ内で実装する必要があります。"
  end

  def after_publication_path
    request.referer || root_path
  end

  # 各モデルに対応するメッセージの作成に使用
  def resource_name
    @resource.class.model_name.human
  end
end