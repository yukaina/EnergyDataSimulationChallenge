class MonthlyEnergyLogsFinder
  def self.averages(city_id: nil)
    monthly_energy_log = MonthlyEnergyLog.
                           group_by_monthly_label.
                           select(
                             :monthly_label_id,
                             "AVG(temperature) AS avarage_temperature",
                             "AVG(daylight) AS avarage_daylight",
                             "AVG(production_volume) AS avarage_production_volume",
                           ).
                           includes(:monthly_label).
                           order(:monthly_label_id)
    return monthly_energy_log unless city_id

    # city ごとに絞る場合は、houses を結合して条件と追加
    monthly_energy_log.
      joins(:house).
      where(houses: { city_id: city_id })
  end

  def self.by_city
    MonthlyEnergyLog.
      select(
        "SUM(temperature) AS total_temperature",
        "SUM(daylight) AS total_daylight",
        "SUM(production_volume) AS total_production_volume",
        "cities.name AS city_name",
      ).
      joins(house: :city).
      group("city_name, cities.id").
      order("cities.id")
  end
end
