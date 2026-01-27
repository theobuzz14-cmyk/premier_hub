module PlayersHelper
  # 2つの値を比較して、左側の選手が占める割合(%)を計算する
  def calculate_ratio(val1, val2)
    val1 = val1.to_f
    val2 = val2.to_f
    return 50 if val1 + val2 == 0 # 両方0なら中央
    (val1 / (val1 + val2) * 100).round
  end

  # 数値を比較して、大きい方に強調色を返す
  def comparison_color(val1, val2)
    return "text-dark" if val1 == val2
    val1 > val2 ? "text-primary fw-bold" : "text-muted"
  end
end