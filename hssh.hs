import Lexer
import Exec
import Control.Monad.Trans.Class
import Control.Monad.Trans.State.Lazy
import System.Exit
import System.Posix.Process
import Text.Parsec
import Data.Text
import TokParser
main :: IO ()
--main = getLine >>= (flip evalStateT getDefaultShellEnv) . exec . unpack . replace (pack "\\\n") (pack "") . pack >> main-- >> exitImmediately ExitSuccess
main = getLine >>= print . parse parseToks "tokenstream" . (\(Right w)-> w) . parse lexer "stdin" --"stdin" "check if \n newline is \" accureately #\n rep#resented \n\""
