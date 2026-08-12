//
//  DetailCoinModel.swift
//  CryptoApp
//
//  Created by Anurag on 12/08/26.
//

import Foundation

//MARK: - Coin Detail Model

struct CoinDetailModel: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let webSlug: String
    let assetPlatformId: String?
    let platforms: [String: String]
    let detailPlatforms: [String: DetailPlatform]
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let categories: [String]
    let previewListing: Bool
    let publicNotice: String?
    let additionalNotices: [String]
    let description: CoinDescription
    let links: CoinLinks
    let image: CoinImage
    let countryOrigin: String
    let genesisDate: String?
    let hasSupplyBreakdown: Bool
    let sentimentVotesUpPercentage: Double?
    let sentimentVotesDownPercentage: Double?
    let watchlistPortfolioUsers: Int?
    let marketCapRank: Int?
    let marketCapRankWithRehypothecated: Int?
    let statusUpdates: [StatusUpdate]
    let lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case webSlug = "web_slug"
        case assetPlatformId = "asset_platform_id"
        case platforms
        case detailPlatforms = "detail_platforms"
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case categories
        case previewListing = "preview_listing"
        case publicNotice = "public_notice"
        case additionalNotices = "additional_notices"
        case description
        case links
        case image
        case countryOrigin = "country_origin"
        case genesisDate = "genesis_date"
        case hasSupplyBreakdown = "has_supply_breakdown"
        case sentimentVotesUpPercentage = "sentiment_votes_up_percentage"
        case sentimentVotesDownPercentage = "sentiment_votes_down_percentage"
        case watchlistPortfolioUsers = "watchlist_portfolio_users"
        case marketCapRank = "market_cap_rank"
        case marketCapRankWithRehypothecated = "market_cap_rank_with_rehypothecated"
        case statusUpdates = "status_updates"
        case lastUpdated = "last_updated"
    }
}

//MARK: - Detail Platform
struct DetailPlatform: Codable {
    let decimalPlace: Int?
    let contractAddress: String?

    enum CodingKeys: String, CodingKey {
        case decimalPlace = "decimal_place"
        case contractAddress = "contract_address"
    }
}

//MARK: - Description
struct CoinDescription: Codable {
    let en: String?
}

//MARK: - Links
struct CoinLinks: Codable {
    let homepage: [String]
    let whitepaper: String?
    let blockchainSite: [String]
    let officialForumURL: [String]
    let chatURL: [String]
    let announcementURL: [String]
    let snapshotURL: String?
    let twitterScreenName: String?
    let facebookUsername: String?
    let bitcointalkThreadIdentifier: String?
    let telegramChannelIdentifier: String?
    let subredditURL: String?
    let reposURL: Repositories

    enum CodingKeys: String, CodingKey {
        case homepage
        case whitepaper
        case blockchainSite = "blockchain_site"
        case officialForumURL = "official_forum_url"
        case chatURL = "chat_url"
        case announcementURL = "announcement_url"
        case snapshotURL = "snapshot_url"
        case twitterScreenName = "twitter_screen_name"
        case facebookUsername = "facebook_username"
        case bitcointalkThreadIdentifier = "bitcointalk_thread_identifier"
        case telegramChannelIdentifier = "telegram_channel_identifier"
        case subredditURL = "subreddit_url"
        case reposURL = "repos_url"
    }
}


//MARK: - Repositories
struct Repositories: Codable {
    let github: [String]
    let bitbucket: [String]
}


//MARK: - Image
struct CoinImage: Codable {
    let thumb: String
    let small: String
    let large: String
}


//MARK: - Status Update
struct StatusUpdate: Codable {
    // Empty because the API currently returns []
}
