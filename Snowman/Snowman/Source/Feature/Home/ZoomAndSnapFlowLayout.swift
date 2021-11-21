//
//  ZoomAndSnapFlowLayout.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//
import UIKit

public class ZoomAndSnapFlowLayout: UICollectionViewFlowLayout {

    public private(set) var activeDistance: CGFloat = 400
    public private(set) var zoomFactor: CGFloat = 1.2

    override init() {
        super.init()

        scrollDirection = .horizontal
        minimumLineSpacing = 140
        itemSize = CGSize(width: 63, height: 90)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepare() {
        guard let collectionView = collectionView else {
            fatalError("CollectionView not exist")
        }
        // swiftlint:disable line_length
        let verticalInsets = (collectionView.frame.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - itemSize.height) / 2

        // swiftlint:disable line_length
        let horizontalInsets = (collectionView.frame.width - collectionView.adjustedContentInset.right - collectionView.adjustedContentInset.left - itemSize.width) / 2

        sectionInset = UIEdgeInsets(
            top: verticalInsets,
            left: horizontalInsets,
            bottom: verticalInsets,
            right: horizontalInsets
        )

        super.prepare()
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }

        let rectAttributes = super.layoutAttributesForElements(in: rect)!
            .map {
                // swiftlint:disable:next force_cast
                $0.copy() as! UICollectionViewLayoutAttributes
            }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)

        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = distance / activeDistance

            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                attributes.zIndex = Int(zoom.rounded())
            }
        }

        return rectAttributes
    }

    public override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {

        guard let collectionView = collectionView else { return .zero }

        let targetRect = CGRect(
            x: proposedContentOffset.x,
            y: 0,
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )

        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }

        return CGPoint(
            x: proposedContentOffset.x + offsetAdjustment,
            y: proposedContentOffset.y
        )
    }

    public override func shouldInvalidateLayout(
        forBoundsChange newBounds: CGRect
    ) -> Bool {
        return true
    }

    public override func invalidationContext(
        forBoundsChange newBounds: CGRect
    ) -> UICollectionViewLayoutInvalidationContext {

        let context = super.invalidationContext(
            forBoundsChange: newBounds
        // swiftlint:disable:next force_cast
        ) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
}
