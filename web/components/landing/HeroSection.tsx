"use client";

import { Button } from "@/components/ui/button";
import { Download } from "lucide-react";
import { cn } from "@/lib/utils";
import { motion } from "motion/react";

const downloadUrl = process.env.NEXT_PUBLIC_DMG_DOWNLOAD_URL;

export function HeroSection() {
  return (
    <section
      className={cn(
        "flex min-h-[100svh] flex-col items-center justify-center gap-6 px-4 py-16 text-center",
        "sm:gap-8 sm:py-24 md:py-32"
      )}
    >
      <motion.h1
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, ease: "easeOut" }}
        className="font-serif text-4xl font-bold tracking-tight sm:text-5xl md:text-6xl"
      >
        Converge
      </motion.h1>
      <motion.p
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, ease: "easeOut", delay: 0.2 }}
        className="max-w-2xl text-lg text-muted-foreground sm:text-xl"
      >
        Pomodoro on Mac. Real focus.
      </motion.p>
      <motion.div
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.5, ease: "easeOut", delay: 0.4 }}
        className="flex flex-col gap-4 sm:flex-row sm:gap-3"
      >
        {downloadUrl ? (
          <motion.div
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            transition={{ duration: 0.2 }}
          >
            <Button asChild size="lg">
              <a
                href={downloadUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2"
              >
                <Download className="size-4" />
                Download for Mac
              </a>
            </Button>
          </motion.div>
        ) : (
          <Button size="lg" disabled>
            <Download className="size-4" />
            Download coming soon
          </Button>
        )}
      </motion.div>
    </section>
  );
}
