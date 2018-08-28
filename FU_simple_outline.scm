(define (FU-simple-outline
        img
        current-layer
        color
        thickness
        feather)

    (gimp-selection-layer-alpha current-layer)
    (gimp-selection-grow img thickness)
    (gimp-selection-feather img feather)

    (let (
            (name (car (gimp-item-get-name current-layer)))
            (index (car (gimp-image-get-layer-position img current-layer)))
            (width (car (gimp-image-width img)))
            (height (car (gimp-image-height img)))
            (new-current-layer (car (gimp-layer-copy current-layer TRUE)))
            (outline-group (car (gimp-layer-group-new img)))
        )
        (gimp-item-set-name outline-group "outline-group")
        (gimp-image-insert-layer img outline-group 0 (+ index 1))
        (let (
                (outline-layer (car (gimp-layer-new img width height RGBA-IMAGE (string-append name " outline") 100 LAYER-MODE-NORMAL-LEGACY)))
            )
            (gimp-image-remove-layer img current-layer)
            (gimp-image-insert-layer img outline-layer outline-group 0)
            (gimp-image-insert-layer img new-current-layer outline-group 0)
            (gimp-palette-set-foreground color)
            (gimp-drawable-edit-fill outline-layer FILL-FOREGROUND)
        )
    )

    (gimp-displays-flush)
    (gimp-selection-none img)

)
(script-fu-register "FU-simple-outline"
    "<Image>/Script-Fu/simple-outline"
    "Automatically add outline"
    "Sukohi Kuhoh"
    "Sukohi Kuhoh"
    "2018"
    "*"
    SF-IMAGE    "Image"         0
    SF-DRAWABLE "Current Layer" 0
    SF-COLOR "Color" '(0 0 0)
    SF-ADJUSTMENT "Thickness" '(4 1 50 1 10 0 0)
    SF-ADJUSTMENT "Feather" '(2 0 50 1 10 0 0)
)
