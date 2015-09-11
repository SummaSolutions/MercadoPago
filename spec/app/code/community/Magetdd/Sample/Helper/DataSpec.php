<?php

namespace spec;

use PhpSpec\ObjectBehavior;
use Prophecy\Argument;

class Magetdd_Sample_Helper_DataSpec
    extends ObjectBehavior
{
    function it_is_initializable()
    {
        $this->shouldHaveType('Magetdd_Sample_Helper_Data');
    }

    function it_should_display_a_low_stock_notice(\Mage_CatalogInventory_Model_Stock_Item $stockItem)
    {
        $stockItem->getQty()->willReturn(3);
        $this->getShouldDisplayLowStockNotice($stockItem)->shouldReturn(true);

    }
}
