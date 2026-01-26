"use client";

import { Button } from "@/components/ui/button";
import { Download } from "lucide-react";
import { cn } from "@/lib/utils";
import { motion } from "motion/react";

const downloadUrl = process.env.NEXT_PUBLIC_DMG_DOWNLOAD_URL;

export function DownloadSection() {
  return (
    <motion.section
      initial="hidden"
      whileInView="visible"
      viewport={{ once: true, margin: "-100px" }}
      className={cn(
        "mx-auto flex min-h-[100svh] max-w-2xl flex-col items-center justify-center px-4 py-16 text-center",
        "sm:py-24 md:py-32"
      )}
    >
      <motion.h2
        variants={{
          hidden: { opacity: 0, y: 20 },
          visible: { opacity: 1, y: 0 },
        }}
        transition={{ duration: 0.6, ease: "easeOut" }}
        className="mb-4 font-serif text-3xl font-bold tracking-tight sm:text-4xl"
      >
        Download Converge
      </motion.h2>
      <motion.p
        variants={{
          hidden: { opacity: 0, y: 20 },
          visible: { opacity: 1, y: 0 },
        }}
        transition={{ duration: 0.6, ease: "easeOut", delay: 0.2 }}
        className="mb-8 text-muted-foreground"
      >
        macOS only. Drag the app to Applications after opening the DMG.
      </motion.p>
      {downloadUrl ? (
        <motion.div
          variants={{
            hidden: { opacity: 0, scale: 0.95 },
            visible: { opacity: 1, scale: 1 },
          }}
          transition={{ duration: 0.5, ease: "easeOut", delay: 0.4 }}
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
        >
          <Button asChild size="lg">
            <a
              href={downloadUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-2"
            >
              <Download className="size-4" />
              Download Converge (DMG)
            </a>
          </Button>
        </motion.div>
      ) : (
        <motion.div
          variants={{
            hidden: { opacity: 0, scale: 0.95 },
            visible: { opacity: 1, scale: 1 },
          }}
          transition={{ duration: 0.5, ease: "easeOut", delay: 0.4 }}
        >
          <Button size="lg" disabled>
            <Download className="size-4" />
            Download coming soon
          </Button>
        </motion.div>
      )}
    </motion.section>
  );
}
