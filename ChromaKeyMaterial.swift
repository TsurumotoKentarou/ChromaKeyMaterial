//
//  ChromaKeyMaterial.swift
//
//  Created by 鶴本賢太朗 on 2019/03/04.
//  Copyright © 2019 Kentarou. All rights reserved.
//

import SceneKit

/**
 * クロマキー合成を行うマテリアル
 */
public class ChromaKeyMaterial: SCNMaterial {
    /**
     * クロマキー合成のシェーダーコード
     */
    private let surfaceShader: String =
    """
        uniform vec3 chromaKeyColor;

        #pragma transparent
        #pragma body

        vec3 textureColor = _surface.diffuse.rgb;
        float thresh = 0.4;
        float slope = 0.2;
        float d = length(chromaKeyColor - textureColor);
        float edge0 = thresh * (1.0 - slope);
        float alpha = smoothstep(edge0, thresh, d);
        _surface.transparent.a = alpha;
    """
    /**
     * 透過にする色
     */
    internal var chromaKeyColor: UIColor {
        didSet { self.setChromakeyColor() }
    }
    init(chromaKeyColor: UIColor = .green) {
        self.chromaKeyColor = chromaKeyColor
        super.init()
        self.setChromakeyColor()
        self.shaderModifiers = [.surface: self.surfaceShader]
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChromaKeyMaterial {
    /**
     * 透過にする色のRGB値をシェーダーに渡す
     */
    private func setChromakeyColor() {
        let rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = self.chromaKeyColor.rgba
        let vector: SCNVector3 = SCNVector3(x: Float(rgba.r), y: Float(rgba.g), z: Float(rgba.b))
        self.setValue(vector, forKey: "chromaKeyColor")
    }
}
