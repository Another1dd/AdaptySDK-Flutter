package com.adapty.flutter.models

import com.adapty.api.entity.paywalls.ProductModel
import com.android.billingclient.api.SkuDetails
import com.google.gson.annotations.SerializedName

class ProductFlutterModel {
    @SerializedName("vendorProductId")
    var vendorProductId: String? = null

    @SerializedName("title")
    var localizedTitle: String? = null

    @SerializedName("localizedDescription")
    var localizedDescription: String? = null

    var variationId: String? = null

    var price: Double? = null

    var localizedPrice: String? = null

    var currencyCode: String? = null

    var currencySymbol: String? = null

    var subscriptionPeriod: ProductSubscriptionPeriodFlutterModel? = null

    @SerializedName("introductoryOfferEligibility")
    var introductoryOfferEligibility = true

    @SerializedName("promotionalOfferEligibility")
    var promotionalOfferEligibility = true

    var introductoryDiscount: ProductDiscountFlutterModel? = null

    var skuDetails: SkuDetails? = null

    companion object {
        fun from(product: ProductModel) = ProductFlutterModel().apply {
            vendorProductId = product.vendorProductId
            localizedTitle = product.localizedTitle
            localizedDescription = product.localizedDescription
            variationId = product.variationId
            price = product.price?.toDouble()
            localizedPrice = product.localizedPrice
            currencyCode = product.currencyCode
            currencySymbol = product.currencySymbol
            subscriptionPeriod = product.subscriptionPeriod?.let(ProductSubscriptionPeriodFlutterModel.Companion::from)
            introductoryOfferEligibility = product.introductoryOfferEligibility
            promotionalOfferEligibility = product.promotionalOfferEligibility
            introductoryDiscount = product.introductoryDiscount?.let(ProductDiscountFlutterModel.Companion::from)
            skuDetails = product.skuDetails
        }
    }
}