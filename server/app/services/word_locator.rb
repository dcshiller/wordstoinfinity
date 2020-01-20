class WordLocator
  def initialize(letters)
    @letters = letters
  end

  def locate
    r = <<~SQL
    WITH subset AS (
      SELECT *
      FROM letters
      WHERE letters.x BETWEEN ? AND ?
        AND letters.y BETWEEN ? AND ?
    ),
    x_consequentialized AS (
      SELECT *,
      x = lag(x) - 1 && y = lag(y) AS x_contiguous,
      FROM subset
    ),
    y_consequentialized AS (
      SELECT *,
      y = lag(y) - 1 && x = lag(x) AS y_contiguous,
      FROM subset
    ),
    grouped AS (),

    SELECT x FROM y
    SQL

    test = <<~SQL
    SELECT *
      FROM letters
    WHERE letters.x BETWEEN ? AND ?
      AND letters.y BETWEEN ? AND ?
    SQL
    sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, [
      test,
      '3',
      '4',
      '1',
      '2',
    ])
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    x = ActiveRecord::Base.connection.execute(sanitized_query);
    debugger
  end
end
