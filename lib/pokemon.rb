class Pokemon
  attr_accessor :name, :type, :db, :id, :hp
  
  @@all = []
  
  def initialize(id: nil, name:, type:, db:, hp: 60)
     @id = id
     self.name = name
     self.type = type
     self.db = db
     self.hp = hp
  end
  
  def self.all
    @@all
  end 
  
  def self.save(name, type, db)
    if self.name == name && self.type == type && self.db == db
      self.update 
    else 
      new_pokemon = Pokemon.new(name: name, type: type, db: db)
      sql_create = <<-SQL
            INSERT INTO pokemon (name, type)  VALUES (?, ?);
      SQL
      new_pokemon.db.execute(sql_create, new_pokemon.name, new_pokemon.type)

      sql_get_id = "SELECT last_insert_rowid() FROM pokemon;"
      new_pokemon.id = new_pokemon.db.execute(sql_get_id)
      @@all << self
    end
 end 
 
 def update
    sql_update = <<-SQL
      UPDATE students SET name = ?, type = ?, db = ? WHERE pokemon.id = ?;
    SQL

    DB[:conn].execute(sql_update, self.name, self.type, self.db, self.id)
  end
  
  def self.find(id, db)
        sql = <<-SQL
            SELECT *
            FROM pokemon
            WHERE id = ?
            LIMIT 1
        SQL
        
        db.execute(sql,id).map do |row|
            self.new(name: row[1], type: row[2], id: row[0], db: db)
        end.first
    end
    
end
