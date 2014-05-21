import Text.XML.Expat.SAX
import System.Environment
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString.Char8 as CH

main = do
    [filename] <- getArgs
    process filename

process :: String -> IO ()
process filename = do
    inputText <- L.readFile filename
    let events = parse defaultParseOptions inputText
    L.putStr $ L.fromChunks $ fff events

fff [] = []
fff (StartElement "ProductUrl" _  : (CharacterData text : rest)) = text : (CH.singleton '\n' :  fff rest)
fff (_ : xs) = fff xs
