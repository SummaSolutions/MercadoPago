<?php

use Behat\Behat\Context\Context;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Behat\Behat\Tester\Exception\PendingException;
use MageTest\MagentoExtension\Context\MagentoContext;

/**
 * Defines application features from the specific context.
 */
class FeatureContext
    extends MagentoContext
    implements Context, SnippetAcceptingContext
{
    /**
     * Initializes context.
     *
     * Every scenario gets its own context instance.
     * You can also pass arbitrary arguments to the
     * context constructor through behat.yml.
     */
    public function __construct()
    {
    }

    /**
     * @Given Product Sku :arg1 has an stock level of :arg2
     */
    public function productSkuHasAnStockLevelOf($arg1, $arg2)
    {
        Mage::app()->setCurrentStore(Mage_Core_Model_App::ADMIN_STORE_ID);
        $product = Mage::getModel('catalog/product')->loadByAttribute('sku', $arg1);
        $sItem = Mage::getModel('cataloginventory/stock_item')->loadByProduct($product->getId());
        $sItem->setQty($arg2)->save();
    }

    /**
     * @When I am on page :arg1
     */
    public function iAmOnPage($arg1)
    {
        $this->getSession()->visit($this->locatePath($arg1));
    }

    /**
     * @Then I should see :arg1
     */
    public function iShouldSee($arg1)
    {
        $page = $this->getSession()->getPage();
        $el = $page->find('css', '.availability-only');
        if ($el) {
            return expect($el->getText())->toBe($arg1);
        }
        throw new RuntimeException('Element not found on the page');
    }
}
