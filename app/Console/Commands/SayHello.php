<?php

namespace App\Console\Commands;

use SmashedEgg\LaravelConsole\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class SayHello extends Command
{
    protected $signature = 'say:hello {name : Name}';

    protected $description = 'Say hello to someone';

    public function handle()
    {
        $this->info('Hello ' . $this->argument('name'));
        return 0;
    }
}