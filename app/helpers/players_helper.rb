module PlayersHelper
  def comparison_color(val1, val2)
    v1 = val1.to_f # nil.to_f は 0.0 になるので安全
    v2 = val2.to_f
    return "" if v1 == v2
    v1 > v2 ? "fw-bold text-dark" : "text-muted"
  end

  def calculate_ratio(val1, val2)
    v1 = val1.to_f
    v2 = val2.to_f
    total = v1 + v2
    return 50 if total == 0
    (v1 / total * 100).round
  end
end