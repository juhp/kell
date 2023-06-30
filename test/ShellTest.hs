import Control.Monad
import Data.Functor ((<&>))
import System.Directory
import System.Exit (ExitCode (..))
import System.Process
import Test.Framework (Test, defaultMain, testGroup)
import Test.Framework.Providers.HUnit
import Test.HUnit (assertFailure)

main :: IO ()
main = execResult >>= defaultMain

execResult :: IO [Test]
execResult = do
  groups <- listDirectory "./test" >>= filterM doesDirectoryExist
  mapM (\dir -> getTests dir <&> testGroup dir) groups
  where
    msg = ["stdout", "stderr", "exitcode"]
    getMsg code = "Test failed: " ++ (msg !! (code -1)) ++ " bash unequal to that of kell"
    getTests dir = do
      scripts <- getDirectoryContents $ "./test/" ++ dir
      return $ createTestC . ("./test/" ++) . (dir ++) <$> scripts
    runTest test = do
      exitCode <- system $ "./test/runTest.sh " ++ test
      case exitCode of
        ExitSuccess -> return ()
        ExitFailure code -> assertFailure $ getMsg (code -1)
    createTestC name = testCase name (runTest name)
