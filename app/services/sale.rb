# Servicio de descuentos globales ("Cyber Day") configurable por variables de entorno.
#   CYBER_DAY_ENABLED=true
#   CYBER_DAY_WEEKDAY=5   (0=Domingo ... 6=Sábado)
#   CYBER_DAY_PERCENT=20
class Sale
  def self.active?
    return false unless ENV["CYBER_DAY_ENABLED"] == "true"

    Date.current.wday == ENV["CYBER_DAY_WEEKDAY"].to_i
  end

  def self.percent
    ENV["CYBER_DAY_PERCENT"].to_i.clamp(0, 100)
  end
end
