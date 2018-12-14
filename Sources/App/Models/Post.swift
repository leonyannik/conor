import Vapor
import Fluent
import Foundation

final class Post: Model {
    var id: Node?
    var content: String
    
    init(content: String) {
        self.id = UUID().uuidString.makeNode()
        self.content = content
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        content = try node.extract("content")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "content": content
        ])
    }
}

extension Post {
    /**
        This will automatically fetch from database, using example here to load
        automatically for example. Remove on real models.
    */
    public convenience init?(from string: String) throws {
        self.init(content: string)
    }
}

extension Post: Preparation {
    static func prepare(_ database: Database) throws {
        //
    }

    static func revert(_ database: Database) throws {
        //
    }
}




final class Building: Model {
    var id: Node?
    var name: String
    var color: String
    var address: String
    var exists: Bool = false
    
    init(name: String, color: String, address: String) {
        self.id = id?.makeNode()//try! UUID().hashValue.makeNode()//UUID().uuidString.makeNode()
        self.name = name
        self.address = address
        self.color = color
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        color = try node.extract("color")
        address = try node.extract("address")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "color": color,
            "address": address
            ])
    }
}

extension Building: Preparation {
    static func prepare(_ database: Database) throws {
        //
        try database.create("buildings") { buildings in
            buildings.id()
            buildings.string("name")
            buildings.string("color")
            buildings.string("address")
        }
    }
    
    static func revert(_ database: Database) throws {
        //
        try database.delete("buildings")
    }
}

extension Building {
    func rooms() throws -> Children<Room> {
        return children()
    }
}




final class Room: Model {
    var id: Node?
    var name: String
    var building_id: Node
    var time: Int
    var exists: Bool = false
    let date = Date()
    
    init(name: String, buildingId: Node) {
        self.id = id?.makeNode()//try! UUID().hashValue.makeNode()//UUID().uuidString.makeNode()
        self.name = name
        self.building_id = buildingId
        self.time = Int(self.date.timeIntervalSince1970)
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        building_id = try node.extract("building_id")
        time = try node.extract("time")
        
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "building_id": building_id,
            "time": time
            ])
    }
}

extension Room {
    func building() throws -> Parent<Building> {
        return try parent(building_id)
    }
    func equipments() throws -> Children<Equipment> {
        return children()
    }
}

extension Room {
    /**
     This will automatically fetch from database, using example here to load
     automatically for example. Remove on real models.
     */
    //    public convenience init?(from string: String, int: Int) throws {
    //        self.init(content: string)
    //    }
}

extension Room: Preparation {
    static func prepare(_ database: Database) throws {
        //
        try database.create("rooms") { room in
            room.id()
            room.parent(Building.self, optional: false)
            room.string("name")
            //pokemons.int("houseId")
            room.int("time")
        }
    }
    
    static func revert(_ database: Database) throws {
        //
        try database.delete("rooms")
    }
}




final class Equipment: Model {
    var id: Node?
    var name: String
    var serialNumber: Int
    var room_id: Node
    var time: Int
    var exists: Bool = false
    let date = Date()
    
    init(name: String, roomId: Node, serialNumber: Int) {
        self.id = id?.makeNode()//try! UUID().hashValue.makeNode()//UUID().uuidString.makeNode()
        self.name = name
        self.room_id = roomId
        self.serialNumber = serialNumber
        self.time = Int(self.date.timeIntervalSince1970)
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        serialNumber = try node.extract("serialNumber")
        room_id = try node.extract("room_id")
        time = try node.extract("time")
        
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "serialNumber": serialNumber,
            "room_id": room_id,
            "time": time
            ])
    }
}

extension Equipment {
    func room() throws -> Parent<Room> {
        return try parent(room_id)
    }
}

extension Equipment {
    /**
     This will automatically fetch from database, using example here to load
     automatically for example. Remove on real models.
     */
    //    public convenience init?(from string: String, int: Int) throws {
    //        self.init(content: string)
    //    }
}

extension Equipment: Preparation {
    static func prepare(_ database: Database) throws {
        //
        try database.create("equipments") { equipment in
            equipment.id()
            equipment.parent(Room.self, optional: false)
            equipment.string("name")
            equipment.int("serialNumber")
            equipment.int("time")
        }
    }
    
    static func revert(_ database: Database) throws {
        //
        try database.delete("equipments")
    }
}
