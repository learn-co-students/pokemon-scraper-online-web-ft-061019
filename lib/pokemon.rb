class Pokemon
   # Responsible for saving, adding, removing, or chaning anything about each pokemon.  You scraper is not responsible for knowing anything about them -- just scraping

   attr_accessor :name, :type, :hp, :db, :id

   @@all = []

   def initialize(id: nil, name:, type:, db:, hp: 60)
      @id = id
      self.name = name
      self.type = type
      self.db = db   
      self.hp = hp
   end
   
   def self.already_exists?(name, type, db)
      self.all.find {|pokemon_obj| pokemon_obj.name == name && pokemon_obj.type == type && pokemon_obj.db == db}
   end
   


   def self.save(name, type, db)
      has_hp = self.db_has_hp?(db)
      exists = Pokemon.already_exists?(name, type, db)
      #binding.pry
      if exists
         exists.update
         #binding.pry
         exists
      elsif has_hp
         new_pokemon = Pokemon.new(name: name, type: type, db: db)
         sql_create = <<-SQL
            INSERT INTO pokemon (name, type, hp)  VALUES (?, ?, ?);
         SQL
         new_pokemon.db.execute(sql_create, new_pokemon.name, new_pokemon.type, new_pokemon.hp)

         sql_get_id = "SELECT last_insert_rowid() FROM pokemon;"
         new_pokemon.id = new_pokemon.db.execute(sql_get_id)
         @@all << new_pokemon
         #binding.pry
         new_pokemon
      else
         new_pokemon = Pokemon.new(name: name, type: type, db: db)
         sql_create = <<-SQL
            INSERT INTO pokemon (name, type)  VALUES (?, ?);
         SQL
         new_pokemon.db.execute(sql_create, new_pokemon.name, new_pokemon.type)

         sql_get_id = "SELECT last_insert_rowid() FROM pokemon;"
         new_pokemon.id = new_pokemon.db.execute(sql_get_id)[0][0]
         @@all << new_pokemon
         #binding.pry
         new_pokemon

      end
   end

   def self.db_has_hp?(db)
      sql_hp = "SELECT * FROM pokemon;"
      # binding.pry
      has_hp = db.execute(sql_hp).length > 3
   end

   def update
      has_hp = self.class.db_has_hp?(self.db)
      if has_hp    
         sql_update = <<-SQL
            UPDATE pokemon SET name = ?, type = ?, hp = ? WHERE id = ?;
         SQL

         self.db.execute(sql_update, self.name, self.type, self.hp, self.id)
      else
         sql_update = <<-SQL
            UPDATE pokemon SET name = ?, type = ? WHERE id = ?;
         SQL

         self.db.execute(sql_update, self.name, self.type, self.id)
      end
   end

   def self.find(id, db)
      sql_find = <<-SQL
         SELECT * FROM pokemon WHERE id = ?;
      SQL

      found_pokemon_row = db.execute(sql_find, id)[0]
      #binding.pry
      if found_pokemon_row.length < 3
         id, name, type = found_pokemon_row
         found_pokemon = Pokemon.new(id: id, name: name, type: type, db: db)
      else
         id, name, type, hp = found_pokemon_row
         found_pokemon = Pokemon.new(id: id, name: name, type: type, db: db, hp: hp)
      end
   end

   def self.all
      @@all
   end

   def alter_hp(new_hp, db)
      self.hp = new_hp
      self.db = db
      #binding.pry
      self.class.save()
      self
   end
end
