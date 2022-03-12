import Foundation
import UIKit

let appId = "app5TlJNpXwxeivZy"
let apiKey = "keyAhUjjIi1SiUUZA"

var allDrinks: [Drink] = []
var orderDrinks: [OrderDrink] = []
var allStores: [Store] = []

// OrderDrink
let sugarList = ["無糖", "一分糖", "二分糖", "微糖", "半糖", "少糖", "正常糖"]
let temperatureList = ["去冰", "微冰", "少冰", "正常冰", "常溫", "溫", "熱"]
let toppingList: [String: Int] = ["珍珠": 10, "紅豆": 10, "布丁": 10, "仙草凍": 10, "綠茶凍": 10, "芋圓": 15, "西米露": 10, "脆啵啵球": 15]

