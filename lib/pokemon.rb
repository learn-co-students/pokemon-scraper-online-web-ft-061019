class Pokemon
    attr_accessor :name, :type, :hp 
    attr_reader :id, :db

    def initialize(id:, name:, type:, db:, hp: nil)
        @id = id 
        @name = name 
        @type = type 
        @hp = hp 
        @db = db 
    end 

    def self.save(name, type, db)
        sql = <<-SQL
        INSERT INTO pokemon(name, type)
        VALUES(?,?)
        SQL

        db.execute(sql, name, type)
        @id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
    end 

    def self.find(id, db)
        sql = <<-SQL
        SELECT * 
        FROM pokemon
        WHERE id = ? 
        SQL

        pokemon = db.execute(sql, id)
        id = pokemon[0][0]
        name = pokemon[0][1]
        type = pokemon[0][2]
        hp = pokemon[0][3]
        new_pokemon = Pokemon.new(id: id, name: name, type: type, db: db, hp:hp)
        new_pokemon
    end 

    def alter_hp(new_hp, db)
        sql = <<-SQL
            UPDATE pokemon 
            SET hp = ? 
            WHERE hp = ?
        SQL

        db.execute(sql, new_hp, hp)
    end 
end
