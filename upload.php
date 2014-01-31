<?php
/* This will upload your file to your server */
?>

<?php

        $filename = "qr-" . time() . ".jpg";
 
        $pngdata = $HTTP_RAW_POST_DATA;
        if( isset( $pngdata ) ) {
                $img_file = fopen ($filename, 'wb');
                fwrite ($img_file, base64_decode( $pngdata ));
                fclose ($img_file);
                echo $filename;
                }
        else {
                echo "Failure.";
                }
?>