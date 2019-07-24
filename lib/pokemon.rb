class Pokemon
    attr_accessor :name, :type, :db, :id

    def initialize(keyword)
    
         
    end 

    def self.save(name, type, db)
        sql = <<-SQL
            INSERT INTO pokemon (name, type) VALUES (?, ?)
            SQL

            DB[:conn].execute(sql, self.name, self.type)
            @id = DB[:conn].execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
    end 
end
