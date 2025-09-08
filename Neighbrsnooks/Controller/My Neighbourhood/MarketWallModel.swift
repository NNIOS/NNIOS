import Foundation

struct MarketWallModel: Codable {
    let status: Int?
    let neighborhood: Neighborhood?
    let verfiedMsg: String?
    let todayList: [AllProductsList]?
    let categories: [MarketCategory]    // Updated type name here
    let allProductsList: [AllProductsList]?
    let wishlist: [AllProductsList]?
    let yourItems: [AllProductsList]?

    enum CodingKeys: String, CodingKey {
        case status, neighborhood
        case verfiedMsg = "verfied_msg"
        case todayList = "today_list"
        case categories
        case allProductsList = "all_products_list"
        case wishlist
        case yourItems = "your_items"
    }
}

enum Neighborhood: String, Codable {
    case sector16A = "Sector 16A"
    case sector18 = "Sector 18"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = Neighborhood(rawValue: try container.decode(String.self)) ?? .unknown
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

enum SaleType: String, Codable {
    case donate = "Donate"
    case sell = "Sell"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = SaleType(rawValue: try container.decode(String.self)) ?? .unknown
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

struct AllProductsList: Codable {
    let id: Int?
    let pTitle, pDescription: String?
    let pQuantity: Int?
    let saleType: String?
    let salePrice: String?
    let brandName: String?
    let sellerName: String?
    let catID: Int?
    let pImages: String?
    let pStatus, neighborhoodID, createdBy: Int?
    let neighborhoodName: String?
    let catName: String?
    let wishlistStatus: Int?
    let createdTime, updatedTime: String?

    enum CodingKeys: String, CodingKey {
        case id
        case pTitle = "p_title"
        case pDescription = "p_description"
        case pQuantity = "p_quantity"
        case saleType = "sale_type"
        case salePrice = "sale_price"
        case brandName = "brand_name"
        case sellerName = "seller_name"
        case catID = "cat_id"
        case pImages = "p_images"
        case pStatus = "p_status"
        case neighborhoodID = "neighborhood_id"
        case createdBy = "created_by"
        case neighborhoodName = "neighborhood_name"
        case catName = "cat_name"
        case wishlistStatus = "wishlist_status"
        case createdTime = "created_time"
        case updatedTime = "updated_time"
    }
}

struct MarketCategory: Codable {   // Renamed struct
    let id: Int?
    let catTitle, catDescription: String?
    let catStatus: Int?
    let catImage: String?
    let catCreateBy, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case catTitle = "cat_title"
        case catDescription = "cat_description"
        case catStatus = "cat_status"
        case catImage = "cat_image"
        case catCreateBy = "cat_create_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
