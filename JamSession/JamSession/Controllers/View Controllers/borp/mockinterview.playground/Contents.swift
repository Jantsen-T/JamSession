import UIKit
func smallMediumLarge2(_ string: String) ->String{
    return String(string.sorted().reversed())
}
func smallMediumLarg(_ string: String) ->String{
    var array = Array(string)
    var finalVersion: [String] = []
    for _ in array{
        if array.contains("s"){
            let index = array.firstIndex(of: "s")!
            finalVersion.append(String(array[index]))
            array.remove(at: index)
        }else if array.contains("m"){
            let index = array.firstIndex(of: "m")!
            finalVersion.append(String(array[index]))
            array.remove(at: index)
        }else if array.contains("l"){
            let index = array.firstIndex(of: "l")!
            finalVersion.append(String(array[index]))
            array.remove(at: index)
        }else{
            break
        }
    }
    var newString = ""
    for element in finalVersion{
        newString += element
    }
    return newString
    
    
}
func ticTacToe(_ board: [[String]]) -> Bool {
    
    func isWin(_ first: String, _ second: String, _ third: String) -> Bool {
        
        guard first != "" else { return false }
        return first == second && first == third
    }
    
    for i in 0 ..< 3 {
        if isWin(board[i][0], board[i][1], board[i][2]) { return true }
        if isWin(board[0][i], board[1][i], board[2][i]) { return true }
    }
    
    return isWin(board[0][0], board[1][1], board[2][2]) || isWin(board[0][2], board[1][1], board[2][0])
}
func isWin(_ chart: [[String]])->Bool{
    for i in 0..<3{
        if chart[i][0]==chart[i][2]&&chart[i][2]==chart[i][1]{
            return true
        }
        if chart[0][i]==chart[1][i]&&chart[1][i]==chart[2][i]{
            return true
        }
    }
    if(chart[0][0]==chart[1][1])&&(chart[1][1]==chart[2][2]){
        return true
    }
    if(chart[0][2]==chart[1][1])&&(chart[1][1]==chart[2][0]){
        return true
    }
    return false
}

func sortString(_ string: String) -> String {
    
    var smallList: [Character] = []
    var mediumList: [Character] = []
    var largeList: [Character] = []
    var unknown: [Character] = []
    
    for i in string {
        if i.lowercased() == "s" {
            smallList.append(i)
            
        } else if i.lowercased() == "m" {
            mediumList.append(i)
            
        } else if i.lowercased() == "l" {
            largeList.append(i)
            
        } else {
            unknown.append(i)
        }
    }
    
    let finalString = smallList + mediumList + largeList
    
    print("There are \(smallList.count) small shirts. \nThere are \(mediumList.count) medium shirts. \nThere are \(largeList.count) large shirts. \nThere are \(finalString.count) total shirts. \nEncountered \(unknown.count) unknown sizes.")
    
    return String(finalString)
}

//sortString(randomString)


func sortString2(_ string: String) -> String {
    return String(string.sorted().reversed())
}



print(isWin([["", "X", ""], ["O", "X", ""], ["O", "", "X"]]))
