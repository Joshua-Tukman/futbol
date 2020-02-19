require 'csv'

module DataLoadable

  def create(file_path, all)
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      params = row.to_hash
      all << new(params)
    end
  end

end
