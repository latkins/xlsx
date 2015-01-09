{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import           Data.Map (Map)
import qualified Data.Map as M
import           Data.Time.Calendar
import           Data.Time.LocalTime
import           System.Time

import           Test.Tasty (defaultMain, testGroup)
import           Test.Tasty.SmallCheck (testProperty)
import           Test.Tasty.HUnit (testCase)

import           Test.HUnit ((@=?))
import           Test.SmallCheck.Series (Positive(..))

import           Codec.Xlsx


main = defaultMain $
  testGroup "Tests"
    [ testProperty "col2int . int2col == id" $
        \(Positive i) -> i == col2int (int2col i)
    , testCase "write . read == id" $
         testXlsx @=? toXlsx (fromXlsx testTime testXlsx)
    , testCase "fromRows . toRows == id" $
         testCellMap @=? fromRows (toRows testCellMap)
    ]

testXlsx :: Xlsx
testXlsx = Xlsx sheets emptyStyles
  where
    sheets = M.fromList [( "List1", sheet )]
    sheet = Worksheet cols rowProps testCellMap []
    rowProps = M.fromList [(1, RowProps (Just 50) (Just 3))]
    cols = [ColumnsWidth 1 10 15 1]

testCellMap :: CellMap
testCellMap = M.fromList [ ((1, 2), cd1), ((1, 5), cd2)
                         , ((3, 1), cd3), ((3, 2), cd4)
                         , ((3, 7), cd5), ((3,8), cd6)
                         ]
  where
    cd v = Cell{_cellValue=Just v, _cellStyle=Nothing, _cellFormula=Nothing}
    cd1 = cd (CellText "just a text")
    cd2 = cd (CellDouble 42.4567)
    cd3 = cd (CellText "another text")
    cd4 = Cell{_cellValue=Nothing, _cellStyle=Nothing, _cellFormula=Nothing} -- shouldn't it be skipped?
    cd5 = cd $(CellBool True)
<<<<<<< HEAD
    cd6 = Cell{_cellValue=Nothing, _cellStyle=Nothing, _cellFormula=Just (CellFormula (Just "A1+B2") [])}
=======
    cd6 = Cell{_cellValue=Nothing, _cellStyle=Nothing, _cellFormula=Just "A1+B2"}
>>>>>>> 59492c6d253908272420203b8fb77654edc76831

testTime :: ClockTime
testTime = TOD 123 567
