require 'pry'

class Pokemon
    attr_accessor :id, :name, :type, :db, :hp

    def initialize (id = nil, name = nil, type = nil, db = nil)
        @id = id
        @name = name
        @type = type
        @hp = hp
        @db = db
    end

    def self.save(name, type, db)
        sql = <<-SQL
            INSERT INTO pokemon (name, type)
            VALUES (?,?)
        SQL

        db.execute(sql, name, type)
    end

    def self.find(id, db)
        info = db.execute("SELECT * FROM pokemon WHERE id = ?", id)
        Pokemon.new(info[0][0], info[0][1], info[0][2])
    end

    def alter_hp(new_hp, db)
        db.execute("UPDATE pokemon SET hp = ? WHERE id = ?", new_hp, self.id)
    end
end
