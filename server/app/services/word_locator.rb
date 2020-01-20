
#
# Locates all words strictly within a radius of a central location
#

class WordLocator
  def initialize(centered_at_x, centered_at_y, radius = 50)
    @x_min = centered_at_x - radius
    @x_max = centered_at_x + radius
    @y_min = centered_at_y - radius
    @y_max = centered_at_y + radius
  end

  def locate
    query = <<~SQL
    WITH subset AS (
      SELECT *
      FROM placements
      WHERE placements.x BETWEEN :x_min AND :x_max
        AND placements.y BETWEEN :y_min AND :y_max
    )

    SELECT STRING_AGG(value, ''), ARRAY_AGG(sum) as max FROM (
      SELECT *,
        SUM(CASE WHEN (lag != (x - 1) OR lag IS NULL) AND x != :x_min THEN 1 ELSE 0 END)
          OVER (PARTITION BY y ORDER BY x)
      FROM ( SELECT *, lag(x) OVER ( PARTITION BY y ORDER BY x ) FROM subset) AS partitioned ) AS marked
      WHERE sum > 0
      GROUP BY y, sum
      HAVING count(*) > 1 AND max(x) < :x_max
    UNION
    SELECT STRING_AGG(value, ''), ARRAY_AGG(sum) as max FROM (
      SELECT *,
        SUM(CASE WHEN (lag != (y - 1) OR lag IS NULL) AND y != :y_min THEN 1 ELSE 0 END)
          OVER (PARTITION BY x ORDER BY y)
      FROM (
        SELECT *, lag(y) OVER ( PARTITION BY x ORDER BY y ) FROM subset) AS partitioned) AS marked
      WHERE sum > 0
      GROUP BY x, sum
      HAVING count(*) > 1 AND max(y) < :y_max;
    SQL

    sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, [
      query,  x_min: @x_min, x_max: @x_max, y_min: @y_min, y_max: @y_max
    ])

    results = ActiveRecord::Base.connection.execute(sanitized_query)
    results.map { |r| r['string_agg'] }
  end
end
