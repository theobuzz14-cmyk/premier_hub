module ApplicationHelper
  def user_avatar(user, size = 40)
    if user.avatar.attached?
      image_tag user.avatar, class: "rounded-circle border", style: "width: #{size}px; height: #{size}px; object-fit: cover;"
    else
      # 画像がない場合はデフォルトのアイコンを表示
      content_tag :div, class: "bg-light rounded-circle d-inline-flex align-items-center justify-content-center border", style: "width: #{size}px; height: #{size}px;" do
        content_tag :i, "", class: "bi bi-person text-muted", style: "font-size: #{size / 2}px;"
      end
    end
  end
end
